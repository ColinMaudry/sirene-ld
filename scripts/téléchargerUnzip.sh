#!/bin/bash

departement=$1

if [[ $departement = "tout" || -z $departement ]]
then
	filename=StockEtablissement_utf8_geo
	csv=$filename.csv
	zip=$csv.gz
	unzip="gzip -d"
else
	filename=geo_siret_$1
        csv=$filename.csv
        zip=$csv.gz
	unzip="gzip -d"

echo "Code département : $departement"
echo ""

fi

ttl=$filename.ttl
hdt=$filename.hdt


rm $filename*

echo "> Téléchargement du fichier compressé..."

wget http://data.cquest.org/geo_sirene/v2019/last/$zip

echo ""
echo "> Extraction du fichier compressé..."

$unzip $zip

echo ""
echo "> Conversion du CSV en RDF (Turtle)..."

time tarql -e UTF-8 sparql/csv2rdf.rq $csv > $ttl

echo ""
echo "Deleting CSV in order to save space on my small disk..."
rm $csv

echo ""
echo "> Conversion du RDF en HDT..."

time rdf2hdt $ttl $hdt

echo ""
echo ">> Terminé"
