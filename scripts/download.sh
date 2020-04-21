#!/bin/bash

# fail on error
set -e
echo $bla
date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

if [ $test -a -z $departements ]
then
  departements="52"
fi

echo "***** Download **********"
echo "Download and extraction started: $date $time"


# -----------------------------------------
# Etablissement
# -----------------------------------------

echo $mytest

if [[ ! -d csv/Etablissement ]]
then
    mkdir -p csv/Etablissement
fi

cd csv/Etablissement

echo "Downloading Etablissement data from http://data.cquest.org/geo_sirene/v2019/last/dep/..."


echo "done"
echo ""

echo "Extracting... "

if [[ ! -z $departements ]]
then
    echo "Downloading and extracting only selected departements ($departements)..."

    rm -rf tmpcsv
    mkdir tmpcsv
 echo "$departements"
    IFS=',' read -ra arrayDep <<< "$departements"
    for dep in "${arrayDep[@]}"
    do
        gz="geo_siret_${dep}.csv.gz"
        csv="geo_siret_${dep}.csv"

        if [[ ! -f $gz ]]
        then
            echo "Downloading $gz..."
            wget -N -c -q -np -nd "http://data.cquest.org/geo_sirene/v2019/last/dep/${gz}"
        fi

        set +e
        echo "Extracting ${gz}..."
        gzip -dkfv $gz
        set -e

        mv $csv tmpcsv
    done

    echo "Removing unselected departement CSVs..."
    rm -f *.csv
    mv tmpcsv/*.csv .
    rm -r tmpcsv

    echo "done"
    echo ""
  else
    echo "Downloading all Etablissement data..."
    rm -f *.csv *.gz
    wget -N -c -q -np -nd http://data.cquest.org/geo_sirene/v2019/last/StockEtablissement_utf8_geo.csv.gz
    set +e
    echo "Extracting..."
    gzip -dfv Stock*
    set -e
fi
cd ../..

# -----------------------------------------
# Unite Legale
# -----------------------------------------
echo "test=$test"
if [[ -z $test ]]
then

  if [[ ! -d csv/UniteLegale ]]; then
    mkdir -p csv/UniteLegale
  fi

  cd csv/UniteLegale



  zip=StockUniteLegale_utf8.zip
  csv=StockUniteLegale_utf8.csv

  if [[ ! -f $zip ]]

  then
    echo "Downloading UniteLegale data from https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip..."
    wget -N -q https://files.data.gouv.fr/insee-sirene/$zip
    echo "done"
    echo ""
  else
    echo "$zip already downloaded."
  fi


  if [[ ! -f $csv ]]
  then
    echo "Extracting... "
    unzip $zip
    echo "done"
    echo ""
  else
    echo "$csv already exists"
  fi
else
  echo "UniteLegale download skipped"
fi

date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo "Download and extraction complete: $date $time"
echo "***** Download **********"
echo ""
