#!/bin/bash

function notify {
  if [[ ! $source ]]
    then
      msgSource=all
    else
      msgSource=$source
  fi
  msgSource=`printf '%-22s' "$msgSource"`
  message=$1
  date=`date +%Y-%m-%d`
  time=`date +%H:%M:%S`

  echo "$date $time | $msgSource | $step > $message"
}
