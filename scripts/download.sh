#!/bin/bash

# fail on error
set -e
source config.sh

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo "***** Download **********"
echo "Download and extraction started: $date $time"


# -----------------------------------------
# Etablissement
# -----------------------------------------

if [[ ! -d csv/Etablissement/full ]]; then
    mkdir -p csv/Etablissement/full
fi
if [[ ! -d csv/Etablissement/light ]]; then
    mkdir -p csv/Etablissement/light
fi

cd csv/Etablissement

echo "Downloading Etablissement data from http://data.cquest.org/geo_sirene/v2019/last/dep/..."

wget -r -q -np -nc -nd -A "gz" http://data.cquest.org/geo_sirene/v2019/last/dep/

echo "done"
echo ""

echo "Extracting... "

set +e
# gzip seems to exit with error 2 when it doesn't overwrite some file
gzip -dkv *.gz
set -e

echo "done"
echo ""

echo "Creating symbolic links of csvs to csv/Etablissement/full and csv/Etablissement/light directories..."

basePath=`pwd`

for csv in `ls *.csv`
do
    # Check that the symbolic link doesn't exist yet
    if [[ ! -h light/$csv ]]
    then
        ln -s $basePath/$csv light/
    fi
done

if [[ $departements -eq "all" ]]
then
    echo mv light/ full/
else

    IFS=',' read -ra arrayDep <<< "$departements"
    for dep in "${arrayDep[@]}"
    do
        # Check that the symbolic link doesn't exist yet
        if [[ ! -h full/geo_siret_$dep.csv ]]
        then
            ln -s $basePath/geo_siret_$dep.csv full/
            rm light/geo_siret_$dep.csv
        fi
    done

fi

echo "done"
echo ""

cd ../..

# -----------------------------------------
# Unite Legale
# -----------------------------------------

if [[ ! -d csv/UniteLegale/full ]]; then
    mkdir -p csv/UniteLegale/full
fi

cd csv/UniteLegale

echo "Downloading UniteLegale data from https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip..."

if [[ ! -f StockUniteLegale_utf8.zip ]]
then
    wget -q https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip

else
    echo "Already downloaded, not downloading again."
fi

echo "done"
echo ""

echo "Extracting... "

if [[ ! -f StockUniteLegale_utf8.csv ]]
then
    unzip StockUniteLegale_utf8.zip
else
    echo "File StockUniteLegale_utf8.csv already exists!"
fi

basePath=`pwd`

if [[ ! -h full/StockUniteLegale_utf8.csv ]]
then
    ln -s $basePath/StockUniteLegale_utf8.csv full/
fi

echo "done"
echo ""

date=`date +%Y-%m-%d`
time=`date +%H:%M:%S`

echo "Download and extraction complete: $date $time"
echo "***** Download **********"
echo ""
