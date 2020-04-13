#!/bin/bash

if [[ ! -z $2 ]]
then
    branch=$1
    server=$2
else
    branch=`git rev-parse --abbrev-ref HEAD`
    server=
fi


echo "server=$name"
echo "branch=$branch"

root=`pwd`
rdf="$root/rdf/sireneld.trig.gz"

if [[ ! -d hdt ]]
then
    mkdir hdt
fi

function makeHdt {
    time rdf2hdt -i -f "trig" "$rdf" $root/hdt/sireneld.hdt
}

case $name in

    hdt)
        mkdir rdf
        curl -s https://sireneld.io/data/sireneld.trig.gz --output sireneld.trig.gz
        makeHdt > log
        mv log finished

    ;;

    main)
        datetime=`date "+%FT%T"`
        name="hdt-cpp-server-$datetime"

        echo "Creating dedicated instance..."
        scw exec -w $(scw start $(scw create --name "$name" --commercial-type="GP1-L" "hdt-cpp")) cd sirene-ld && git checkout $branch && git pull origin "$branch" && make hdtOnly hdt
        echo "Done, processing started..."

        # Clear cache (see bug in scw: https://github.com/scaleway/scaleway-cli/issues/531)
        rm ~/.scw-cache.db

        ip=`scw inspect "$name" | jq -r '.[0].public_ip.address'`

        #wait for HDT
        while [[ ! -f finished ]]
        do
            # I wish I could use scw cp but... : https://github.com/scaleway/scaleway-cli/issues/537
            scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q root@${ip}:/root/sirene-ld/finished . 2>&1 | grep "xx"

            # #GreenIT
            sleep 60
        done

        echo "Processing finished. Printing logs:"
        echo ""
        echo "========================"

        # HDT is ready, show the Scaleway server logs
        cat finished

        echo "========================"
        echo ""

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
        makeHdt

    ;;
esac
