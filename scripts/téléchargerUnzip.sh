#!/bin/bash

departement=$1

if [ $departement = "tout"  ]
then
	filename=geo_sirene
	csv=$filename.csv
	zip=$csv.gz
	unzip="gzip -d"
else
	filename=geo-sirene_$1
        csv=$filename.csv
        zip=$csv.7z
	unzip="p7zip -d"

echo "Code département : $departement"
echo ""

fi

ttl=$filename.ttl
hdt=$filename.hdt


rm $filename*

echo "> Téléchargement du fichier compressé..."

wget http://data.cquest.org/geo_sirene/last/$zip

echo ""
echo "> Extraction du fichier compressé..."

$unzip $zip

echo ""
echo "> Conversion du CSV en RDF (Turtle)..."

time tarql -e UTF-8 sparql/csv2rdf.rq $csv > $ttl

echo ""
echo "> Conversion du RDF en HDT..."

time rdf2hdt $ttl $hdt

echo ""
echo ">> Terminé"
