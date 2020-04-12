#!/bin/bash

type=$1
root=`pwd`
rdf="$root/rdf/rdf.trig"

if [[ ! -d rdf ]]
then
    mkdir rdf
fi

if [[ ! -f $rdf ]]
then
    echo "
@prefix sn: <https://sireneld.io/vocab/sirene#> .
@prefix sx: <https://sireneld.io/vocab/sirext#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xs: <http://www.w3.org/2001/XMLSchema#> .
@prefix geo-pos: <http://www.w3.org/2003/01/geo/wgs84_pos#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix sirecj: <https://sireneld.io/vocab/sirecj> .

    " > $rdf;
fi

echo "rdf:	$rdf";
echo "type:	$type";

function EtablissementUniteLegale {
    echo "<urn:graph:${type,,}> {" >> $rdf

    cd csv/$type
    csvs=`ls *.csv`
    echo $csvs
    tarql $root/sparql/${type}2rdf.rq $csvs | grep -v "^@" >> $rdf
    echo "}" >> $rdf
}

case "$type" in

    Etablissement)
        EtablissementUniteLegale $type
    ;;

    UniteLegale)
        EtablissementUniteLegale $type
    ;;

    ontologies)
        echo "<urn:graph:${type,,}> {" >> $rdf
        cd $root/$type
        cat *.ttl | grep -v "^@" >> $rdf
        echo "}" >> $rdf
    ;;

    nomenclatures)
        echo "<urn:graph:${type,,}> {" >> $rdf
        cd $root/$type
        cat *.ttl | grep -v "^@" >> $rdf
        echo "}" >> $rdf
    ;;

    *)
        rm $root/rdf/rdf.trig
        for type in Etablissement UniteLegale ontologies nomenclatures
        do
            $root/scripts/rdf.sh $type
        done
    ;;

esac
