#!/bin/bash

function notify {
 if [[ ! $source ]]
 then
 msgSource=all
 else
 msgSource=$source
 fi
 msgSource=`printf '%-22s' "$msgSource"`
 message=$1
 step="download"
 date=`date +%Y-%m-%d`
 time=`date +%H:%M:%S`

 echo "$date $time | $msgSource | $step > $message"
}

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
