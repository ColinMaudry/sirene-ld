#!/bin/bash

source $root/scripts/functions.sh

# fail on error
set -e

notify "Output: $sourceRdf"

jq -r -f $root/scripts/sources/$source/rdf.jq  $source.json > $sourceRdf

notify "Finished step"

