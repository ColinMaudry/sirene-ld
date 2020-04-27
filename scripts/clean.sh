#!/bin/bash

target=$1

case $target in 
  
  sources)
    if [[ $source ]]
    then
      rm -rf $root/sources/$source
    else
      rm -rf $root/sources/*/
    fi
  ;;

  rdf)
    if [[ $source ]]
    then 
      rm -rf $root/rdf/$source.*
    else 
      rm -rf $root/rdf
    fi
  ;;

  hdt)
    rm -rf $root/hdt
  ;;
esac
