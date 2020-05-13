#!/bin/bash

source $root/scripts/functions.sh

# fail on error
set -e

# Download

if [[ ! -s $source.json ]]
then
  curl -sL https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2 -o $source.json
else
  notify "Already downloaded!"
fi

notify "Finished step"

