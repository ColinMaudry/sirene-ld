#!/bin/bash
root=`pwd`
gz=${rdf}.gz
gzFile=${rdfFile}.gz


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


echo "server=$server"
echo "branch=$branch"

if [[ ! -d hdt ]]
then
    mkdir hdt
fi

function makeHdt {
    gz=$1
    echo "$server: about to process $gz for HDT conversion."
    time rdf2hdt -i -f nt "$gz" $root/hdt/sireneld.hdt
}

case $server in

    hdt)
        if [[ ! -d rdf ]]
        then
            mkdir rdf
        fi
        echo "$server: pwd=$(pwd)"
        echo "$server: gz=$gz"
        ls rdf
        makeHdt $gz

        echo "done" > finished
    ;;

    main)
        datetime=`date "+%FT%T"`
        name="hdt-cpp-server-$datetime"

        echo "$server: Creating dedicated instance in the background..."
        id=`scw start $(scw create --name "$name" $scalewayType $image)`
        scw exec -w $id "cd sirene-ld && git pull && git checkout $branch && git pull origin $branch && mkdir rdf"

        echo "$server: Server created and started."

        # Clear cache (see bug in scw: https://github.com/scaleway/scaleway-cli/issues/531)
        rm ~/.scw-cache.db

        ip=`scw inspect "$id" | jq -r '.[0].public_ip.address'`

        echo "$server: Sending $gz to the server..."
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q $gz root@${ip}:/root/sirene-ld/rdf/

        echo "$server: $(date +%H:%M:%S): starting HDT creation... ${type}..."
        scw exec -w $id "cd /root/sirene-ld && make hdtOnly branch="$branch" server='hdt'" &
        echo "$server: HDT processing started..."
        #wait for HDT


        while [[ ! -f finished ]]
        do
            # I wish I could use scw cp but... : https://github.com/scaleway/scaleway-cli/issues/537
            scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/finished . 2>&1 | grep "xx"

            sleep 10
        done

        echo "$server: $(date +%H:%M:%S): finished HDT creation."
        rm finished
        echo "Downloading HDT from instance server..."
        # Download HDT from Scaleway server
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/hdt/* ./hdt/
        echo "done"

        echo "Deleting instance server..."
        # Delete the server
        scw rm -f "$id"
        echo "done"
    ;;

    *)
        echo "Processing HDT locally..."
        makeHdt

    ;;

esac
