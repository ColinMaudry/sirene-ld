#!/bin/bash

# fail on error
set -e

echo "Format : $format"

source config.sh
IFS=',' read -ra ADDR <<< "$departements"
for dep in "${ADDR[@]}"
do
    echo $dep


date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo "***** Download **********"
echo "Download and extraction started: $date $time"

echo ""
echo "Downloading departements..."

baseUrl="http://data.cquest.org/geo_sirene/v2019/last/dep/"



# Dep exemple : http://data.cquest.org/geo_sirene/v2019/last/dep/geo_siret_35.csv.gz


filename=geo_siret_${dep}.csv
zip=$filename.gz
csv=$filename
unzip="gzip -d"

if [[ -s csv/$csv ]]; then

echo "> csv/$csv déjà présent : pas de téléchargement"

else

    if [[ ! -d csv ]]; then
        mkdir csv
    fi

    echo "> Téléchargement de $zip..."

    wget $baseUrl$zip -O csv/$zip

    echo ""
    echo "> Extraction de $zip..."

    $unzip csv/$zip

fi
done

date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo "Download and extraction complete: $date $time"
echo "***** Download **********"
echo ""
