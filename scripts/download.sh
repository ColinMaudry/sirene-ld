#!/bin/bash

# fail on error
set -e
export step=download
source $root/scripts/functions.sh

if [[ $source ]]
then

  if [ -d $root/scripts/sources/$source -a -f $root/scripts/sources/$source/download.sh ]
      then

     notify "Starting download..." 
     
      # If data is already here, we keep it...
      if [[ -d $root/sources/$source ]]
        then
          notify "Data already downloaded, exiting."
          exit 0
      else
        mkdir $root/sources/$source
        cd $root/sources/$source

        $root/scripts/sources/$source/download.sh $source
      fi
  else
     notify "This source doesn't exit.'"
      echo ""

      exit 1
  fi
else
  echo "======================================================="
  notify "Starting download for all sources...."
  echo ""

  sources=`jq -r '.[] | .code' $root/sources/metadata.json`

 for source in $sources
 do

   make -s download source=$source &
 done

 # Waiting for parrallel downloads to finish
 wait

 echo ""
 notify "All downloads finished."
 echo "========================================="
fi
