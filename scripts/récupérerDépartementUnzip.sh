#!/bin/bash

departement=$1
filename=geo-sirene_$departement
csv=$filename.csv
zip=$csv.7z
ttl=$filename.ttl
hdt=$filename.hdt


rm $filename*

echo "Code département : $departement"
echo ""
echo "> Téléchargement du fichier compressé..."

wget http://data.cquest.org/geo_sirene/last/$zip

echo ""
echo "> Extraction du fichier compressé..."

p7zip -d $zip

echo ""
echo "> Conversion du CSV en RDF (Turtle)..."

time tarql -e UTF-8 sparql/csv2rdf.rq $csv > $ttl

echo ""
echo "> Conversion du RDF en HDT..."

time rdf2hdt $ttl $hdt

echo ""
echo ">> Terminé"
