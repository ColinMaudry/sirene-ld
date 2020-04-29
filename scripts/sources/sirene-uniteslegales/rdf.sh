#!/bin/bash

source $root/scripts/functions.sh

csvs=`ls *.csv`
notify "Input: $csvs"
notify "Output: $sourceRdf"
tarqlCommand="time tarql --ntriples $root/sparql/${source}2rdf.rq $csvs"


if [[ $output == "nq" ]]
then
 time tarql --ntriples $root/sparql/${source}2rdf.rq $csvs | sed "s/\.$/<urn:graphs:${source}> ./" | gzip -9 - > $sourceRdf
else
 time tarql --ntriples $root/sparql/${source}2rdf.rq $csvs | gzip -9 - > $sourceRdf
fi

notify "Finished step"
