#!/bin/bash
root=`pwd`
rof="$root/rdf/sireneld.trig.gz"

if [[ -z $test ]]
then
  branch=$1
  server=$2
  scalewayType="GP1-L"
else
  branch=`git rev-parse --abbrev-ref HEAD`
  server=main
  scalewayType="GP1-L"
  scp $rdf soyou:git/sirene-ld/rdf/
fi


echo "server=$server"
echo "branch=$branch"

root=`pwd`

if [[ ! -d hdt ]]
then
    mkdir hdt
fi

function makeHdt {
    time rdf2hdt -i -f "trig" "$rdf" $root/hdt/sireneld.hdt
}

case $server in

    hdt)
        if [[ ! -d rdf ]]
        then
            mkdir rdf
        fi
        curl https://sireneld.io/data/sirene/sireneld.trig.gz --output rdf/sireneld.trig.gz
        makeHdt > log
        mv log finished

    ;;

    main)
        datetime=`date "+%FT%T"`
        name="hdt-cpp-server-$datetime"

        echo "Creating dedicated instance in the background..."
        scw exec -w $(scw start $(scw create --name "$name" --commercial-type="$scalewayType" "hdt-cpp")) "cd sirene-ld && git checkout $branch && git pull origin $branch && make hdtOnly branch="$branch" server='hdt'"
        echo "Server created."

        # Clear cache (see bug in scw: https://github.com/scaleway/scaleway-cli/issues/531)
        rm ~/.scw-cache.db

        ip=`scw inspect "$name" | jq -r '.[0].public_ip.address'`
        scw exec -w $name "cd sirene-ld && git checkout $branch && git pull origin $branch && make hdtOnly branch="$branch" server='hdt'" &
        echo "HDT processing started..."
        #wait for HDT
        while [[ ! -f finished ]]
        do
            # I wish I could use scw cp but... : https://github.com/scaleway/scaleway-cli/issues/537
            scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/finished . 2>&1 | grep "xx"

            # #GreenIT
            sleep 60
        done

        echo "Processing finished."

        echo "Downloading HDT from instance server..."
        # Download HDT from Scaleway server
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/hdt/* ./hdt/
        echo "done"

        echo "Deleting instance server..."
        # Delete the server
        scw rm -f "$name"
        echo "done"
    ;;

    *)
        echo "Processing HDT locally..."
        makeHdt

    ;;

esac
