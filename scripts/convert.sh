#!/bin/bash

# fail on error
set -e

source config.sh

if [[ -z $1 ]]
then
    echo "Error: you must provide Etablissement or UniteLegale as \$1"
    exit 1
else
    type=$1
fi

if [[ -z $2 ]]
then
    lightfull="full"
else
    lightfull=$2
fi

date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo ""
echo "***** Convert **********"
echo "Conversion $lightfull $type started: $date $time"

basePath=`pwd`

if [[ ! -d rdf ]]
then
    mkdir rdf
fi

cd csv/$type/$lightfull

if [[ -f $basePath/rdf/${lightfull}${type}.nt.gz ]]
then
    rm $basePath/rdf/${lightfull}${type}.nt.gz
fi

echo "Converting $lightfull $type data..."
# for csv in `ls`
# do
    cat * | tarql -e UTF-8 --ntriples $basePath/sparql/${lightfull}${type}2rdf.rq | gzip -9 > $basePath/rdf/${lightfull}${type}.nt.gz
# done


date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo "Conversion $lightfull $type ended: $date $time"
echo "***** Convert **********"
echo ""
