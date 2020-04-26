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
  step="download"
  date=`date +%Y-%m-%d`
  time=`date +%H:%M:%S`

  echo "$date $time | $msgSource | $step > $message"
}

if [[ ! -d rdf ]]
then
    mkdir rdf
fi

echo "rdf:	$rdf";
echo "type:	$type";

function EtablissementUniteLegale {
    type=$1

    cd csv/$type
    csvs=`ls *.csv`
    echo $csvs
    tarqlCommand="time tarql --ntriples $root/sparql/${type}2rdf.rq $csvs"

    echo "$(date +%H:%M:%S): starting RDF conversion of ${type}..."

    if [[ $output == "nq" ]]
    then
      time tarql --ntriples $root/sparql/${type}2rdf.rq $csvs | sed "s/\.$/<urn:graphs:${type,,}> ./" >> $rdf
    else
      time tarql --ntriples $root/sparql/${type}2rdf.rq $csvs >> $rdf
      echo "No quad output. Triple output for $type."
    fi

    echo "$(date +%H:%M:%S): finished RDF conversion of ${type}."
}

function SupportData {
    type=$1

    cd $root/$type
    mkdir nt
    for ttl in `ls *.ttl`
    do
      rdf2rdf -in $ttl -out nt/$ttl.nt
    done
    cp *.nt nt

    if [[ $output == "nq" ]]
    then
      cat nt/*.nt | sed "s/\.$/<urn:graphs:${type,,}> ./" >> $rdf
    else
      cat nt/*.nt  >> $rdf
      echo "No quad output. Triple output for $type."
    fi

    rm -r nt
}


case "$type" in

    Etablissement)
        EtablissementUniteLegale $type
    ;;

    UniteLegale)
      if [[ -z $test ]]
      then
        EtablissementUniteLegale $type
      fi
    ;;

    ontologies)
        SupportData $type
    ;;

    nomenclatures)
        SupportData $type
    ;;

    *)
        echo "No type provided, do them all..."
        rm -f $rdf
        for type in Etablissement UniteLegale ontologies nomenclatures
        do
            $root/scripts/rdf.sh $type
        done
        echo "$(date +%H:%M:%S): finished RDF conversion."
    ;;
esac

cd $root/rdf
