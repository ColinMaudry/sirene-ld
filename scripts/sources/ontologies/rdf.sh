#!/bin/bash

source $root/scripts/functions.sh

mkdir nt

for ttl in `ls *.ttl`
do
  rdf2rdf -in $ttl -out nt/$ttl.nt
done

cp *.nt nt

if [[ $output == "nq" ]]
then
  cat nt/*.nt | sed "s/\.$/<urn:graphs:${source}> ./" | gzip -9 - > $sourceRdf
else
  cat nt/*.nt | gzip -9 - > $sourceRdf
fi

rm -r nt

notify "Finished step."
