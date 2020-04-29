#!/bin/bash

export step=rdf
source $root/scripts/functions.sh

if [[ ! -d rdf ]]
then
    mkdir rdf
fi

if [[ $source ]]
then
  if [ -d $root/scripts/sources/$source -a -f $root/scripts/sources/$source/rdf.sh ]
  then

    notify "Starting RDF processing..."

    # If data is already here, we keep it...
    if [[ -d $root/rdf/$source ]]
    then
      notify "Data already processed, exiting."
      exit 0
    else
      cd $root/sources/$source
      export sourceRdf="$root/rdf/$source.$output.gz"
      notify "Starting RDF processing..."
      $root/scripts/sources/$source/rdf.sh $source
      notify "Finished RDF processing."
    fi
  elif [ ! -f $root/scripts/sources/$source/rdf.sh ]
  then
    notify "No rdf.sh for $source."
    exit 0
  else
    notify "This source doesn't exist.'"
    echo ""

    exit 1
  fi
else
  echo "======================================================="
  notify "Starting RDF processing for all sources...."

  sources=`jq -r '.[] | .code' $root/sources/metadata.json`

  for source in $sources
  do
    make -s rdfOnly source=$source &
  done

  # Waiting for parrallel downloads to finish
  wait

  echo ""
  notify "All RDF processing finished."
  echo "========================================="
fi

