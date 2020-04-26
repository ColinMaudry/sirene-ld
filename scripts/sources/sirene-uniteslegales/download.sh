#!/bin/bash

function notify {
  source=$1
  message=$2 
  step="download"
  date=`date +%Y-%m-%d`
  time=`date +%H:%M:%S`

  echo "$date $time | $source | $step > $message"
}


if [[ -z $test ]]
then
  zip=StockUniteLegale_utf8.zip
  csv=StockUniteLegale_utf8.csv

  if [[ ! -f $zip ]]
  then
    notify $source "Downloading data from https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip..."
    wget -N -q https://files.data.gouv.fr/insee-sirene/$zip
  else
    echo "$zip already downloaded."
  fi


  if [[ ! -f $csv ]]
  then
    notify $source "Starting ZIP extraction... "
    unzip $zip
  else
    notify $source "$csv already exists"
  fi
else
  notify $source "UniteLegale download skipped for testing"
fi

notify $source "Finished step."
