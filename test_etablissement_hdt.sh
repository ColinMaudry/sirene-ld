#!/bin/bash

csv=$1
ext=$3
type=$2
rdf="$csv.$ext"


echo "csv:	$csv"
echo "rdf:	$rdf"
echo "ext:	$ext"
echo "type:	$type"


if [[ $ext -eq "nt" ]]
then
	format="--ntriples"
fi

time tarql $format -e UTF-8  sparql/full${type}2rdf.rq $csv > $rdf
time rdf2hdt -f $ext $rdf  $rdf.hdt

ls -lh $rdf
ls -lh $rdf.hdt
