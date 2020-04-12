#!/bin/bash

root=`pwd`
rdf="$root/rdf/sireneld.trig"

if [[ ! -d hdt ]]
then
    mkdir hdt
fi

nbLines=`cat $rdf | wc -l`

if [[ ! $server ]]
    time rdf2hdt -i -f "trig" "$rdf"  $root/hdt/sireneld.hdt
fi
