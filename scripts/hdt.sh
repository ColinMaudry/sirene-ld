#!/bin/bash
root=`pwd`
gz=${rdf}.gz
gzFile=${rdfFile}.gz
hdt=$root/hdt/sireneld.hdt


export step=hdt
source $root/scripts/functions.sh


if [[ -z $test ]]
then
  branch=$1
  server=$2
  scalewayType="--commercial-type=GP1-L"
  image="hdt-cpp"
else
  branch=`git rev-parse --abbrev-ref HEAD`
  server=main
  scalewayType=""
  image="hdt-cpp-test"
fi


notify "server=$server"
notify "branch=$branch"

if [[ ! -d hdt ]]
then
    mkdir hdt
fi

function makeHdt {
    gz=$1
    notify "$server: about to process $gz for HDT conversion."
    time rdf2hdt -i -f nt "$gz" $hdt
}

case $server in

    hdt)
        if [[ ! -d rdf ]]
        then
            mkdir rdf
        fi
        notify "$server: pwd=$(pwd)"
        notify "$server: gz=$gz"
        ls rdf
        makeHdt $gz
        
        if [[ -f $hdt ]]
        then
          notify "$server: HDT complete"
        else
          notify "$server: HDT creation failed"
        fi
        notify "done" > finished
    ;;

    main)
        datetime=`date "+%FT%T"`
        name="hdt-cpp-server-$datetime"

        notify "$server: Creating dedicated instance in the background (Scaleway $scalewayType)..."
        id=`scw start $(scw create --name "$name" $scalewayType $image)`
        scw exec -w $id "cd sirene-ld && git pull && git checkout $branch && git pull origin $branch && mkdir rdf"

        notify "$server: Server created and started."

        # Clear cache (see bug in scw: https://github.com/scaleway/scaleway-cli/issues/531)
        rm ~/.scw-cache.db

        ip=`scw inspect "$id" | jq -r '.[0].public_ip.address'`

        notify "$server: Sending $gz to the server..."
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q $gz root@${ip}:/root/sirene-ld/rdf/
        notify "$server: $gz sent"

        notify "$server: starting HDT creation... "
        scw exec -w $id "cd /root/sirene-ld && make hdtOnly branch="$branch" server='hdt'" &
        notify "$server: HDT processing started..."
        #wait for HDT


        while [[ ! -f finished ]]
        do
            # I wish I could use scw cp but... : https://github.com/scaleway/scaleway-cli/issues/537
            scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/finished . 2>&1 | grep "xx"

            sleep 30
        done

        notify "$server: finished HDT creation."
        rm finished
        notify "Downloading HDT from instance server..."
        # Download HDT from Scaleway server
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/hdt/* ./hdt/
        notify "HDT downloaded"

        notify "Deleting instance server (Scaleway $scalewayType)..."
        # Delete the server
        scw rm -f "$id"
        notify "Instance server deleted"
    ;;

    *)
        notify "Processing HDT locally..."
        makeHdt

    ;;

esac
