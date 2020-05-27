#!/bin/bash
source $root/scripts/functions.sh

# fail on error
set -e

notify "Conversion from TTL to NT..."
for file in `ls *.ttl`
do
  nt=$file.nt
  if [[ ! -f $nt ]]
  then
    rdf2rdf -in $file -out $nt
  else
    notify "$nt already exists."
  fi
done

notify "All NT in one file ($sourceRdf)..."
cat *.nt | gzip -9 >> $sourceRdf

notify "Finished step"


