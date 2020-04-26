#!/bin/bash

# fail on error
set -e

function notify {
  source=$1
  message=$2
  step="download"
  date=`date +%Y-%m-%d`
  time=`date +%H:%M:%S`

  echo "$date $time | $source | $step > $message"
}

if [[ ! -z $departements ]]
then
    notify $source "Downloading and extracting only selected departements ($departements)..."

    rm -rf tmpcsv
    mkdir tmpcsv
    IFS=',' read -ra arrayDep <<< "$departements"
    for dep in "${arrayDep[@]}"
    do
        gz="geo_siret_${dep}.csv.gz"
        csv="geo_siret_${dep}.csv"

        if [[ ! -f $gz ]]
        then
            notify $source "Downloading $gz..."
            wget -N -c -q -np -nd "http://data.cquest.org/geo_sirene/v2019/last/dep/${gz}"
        fi

        set +e
        notify $source "Extracting ${gz}..."
        gzip -dkfv $gz
        set -e

        mv $csv tmpcsv
    done

    # Removing unselected departement CSVs...
    rm -f *.csv
    mv tmpcsv/*.csv .
    rm -r tmpcsv
  else
    notify $source "Downloading all departments data..."
    rm -f *.csv *.gz
    wget -N -c -q -np -nd http://data.cquest.org/geo_sirene/v2019/last/StockEtablissement_utf8_geo.csv.gz
    set +e
    notify $source "Extracting..."
    gzip -dfv Stock*
    set -e
fi

notify $source "Finished step"

