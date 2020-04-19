#!/bin/bash

type=$1
root=`pwd`


if [[ ! -d rdf ]]
then
    mkdir rdf
fi

echo "rdf:	$rdf";
echo "type:	$type";

function EtablissementUniteLegale {
    type=$1

    cd csv/$type
    csvs=`ls *.csv`
    echo $csvs
    tarql --ntriples $root/sparql/${type}2rdf.rq $csvs | sed "s/\.$/<urn:graph:${type,,}>./" >> $rdf
}

function SupportData {
    type=$1
    cd $root/$type
    mkdir nt
    for ttl in `ls *.ttl`
    do
      rdf2rdf -in $ttl -out nt/$ttl.nt
    done
    cp *.nt nt
    cat nt/*.nt | sed "s/\.$/<urn:graph:${type,,}>./" >> $rdf
    rm -r nt
}


case "$type" in

    Etablissement)
        EtablissementUniteLegale $type
    ;;

    UniteLegale)
      if [[ -z $test ]]
      then
        EtablissementUniteLegale $type
      fi
    ;;

    ontologies)
        SupportData $type
    ;;

    nomenclatures)
        SupportData $type
    ;;

    *)
        echo "No type provided, do them all..."
        rm -f $rdf
        for type in Etablissement UniteLegale ontologies nomenclatures
        do
            $root/scripts/rdf.sh $type
        done
    ;;
esac

cd $root/rdf
