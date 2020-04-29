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
  step="rdf"
  date=`date +%Y-%m-%d`
  time=`date +%H:%M:%S`

  echo "$date $time | $msgSource | $step > $message"
}


mkdir nt

for ttl in `ls *.ttl`
do
  rdf2rdf -in $ttl -out nt/$ttl.nt
done

cp *.nt nt

if [[ $output == "nq" ]]
then
  cat nt/*.nt | sed "s/\.$/<urn:graphs:${source}> ./" >> $rdf
else
  cat nt/*.nt  >> $rdf
fi

rm -r nt

notify "Finished step."
