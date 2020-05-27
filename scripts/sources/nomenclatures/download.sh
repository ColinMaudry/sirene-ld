#!/bin/bash

source $root/scripts/functions.sh

# fail on error
set -e

notify "CPV: downloading CPV data from http://cpv.data.ac.uk/..."
curl -sL http://cpv.data.ac.uk/turtle/dump.ttl -o cpv.ttl

notify "Adapting UK CPV data to sireneld (URIs)..."
sed -i "s/http\:\/\/purl.org\/cpv\/2008/https:\/\/sireneld.io\/cpv/" cpv.ttl
sed -i "s/code\-//" cpv.ttl

notify "Copying /nomenclatures/* to /sources/nomenclatures..."
cp $root/nomenclatures/* .

notify "Finished step"
