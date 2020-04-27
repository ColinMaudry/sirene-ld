#!/bin/bash

function notify {
  message=$1
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
    notify "Downloading data from https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip..."
    wget -N -q https://files.data.gouv.fr/insee-sirene/$zip
  else
    echo "$zip already downloaded."
  fi


  if [[ ! -f $csv ]]
  then
    notify "Starting ZIP extraction... "
    unzip $zip
  else
    notify "$csv already exists"
  fi
else
  notify "UniteLegale download skipped (test=test)"
fi

notify "Finished step."
