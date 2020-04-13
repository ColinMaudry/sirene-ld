#!/bin/bash

server=$1
branch=$2


echo "server=$server"

root=`pwd`
rdf="$root/rdf/sireneld.trig.gz"

if [[ ! -d hdt ]]
then
    mkdir hdt
fi

function makeHdt {
    time rdf2hdt -i -f "trig" "$rdf" $root/hdt/sireneld.hdt
}

case $server in

    hdt)
        mkdir rdf
        curl -s https://sireneld.io/data/sireneld.trig.gz --output sireneld.trig.gz
        makeHdt > log
        mv log finished

    ;;

    main)

        server="hdt-cpp-server"


        # Pop dedicated instance
        scw exec -w $(scw start $(scw create --name "$server" --commercial-type="GP1-L" "hdt-cpp")) cd sirene-ld && git checkout $branch && git pull origin $branch && make hdtOnly hdt

        rm ~/.scw-cache.db

        ip=`scw inspect "$server" | jq -r '.[0].public_ip.address'`

        #wait for HDT
        while [[ ! -f finished ]]
        do
            scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/finished . 2>&1 | grep "xx"
            sleep 60
        done

        # HDT is ready
        cat finished

        # Download HDT
        scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/hdt/* ./hdt/

        # Delete the server
        scw rm -f $server
    ;;

    *)
    makeHdt

    ;;
esac
