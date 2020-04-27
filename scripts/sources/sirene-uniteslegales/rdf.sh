#!/bin/bash

source $root/scripts/functions.sh

csvs=`ls *.csv`
notify "Input: $csvs"
notify "Output: $rdf"
tarqlCommand="time tarql --ntriples $root/sparql/${source}2rdf.rq $csvs"


if [[ $output == "nq" ]]
then
 time tarql --ntriples $root/sparql/${source}2rdf.rq $csvs | sed "s/\.$/<urn:graphs:${source}> ./" >> $rdf
else
 time tarql --ntriples $root/sparql/${source}2rdf.rq $csvs >> $rdf
fi

notify "Finished step"
