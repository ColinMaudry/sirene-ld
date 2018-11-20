#!/bin/bash

types=("Etablissement" "UniteLegale")

for type in $types
do

	filename=Stock${type}_utf8
	csv=$filename.csv
	zip=$filename.zip
	unzip="unzip -o"

nt=$filename.nt
hdt=$filename.hdt

# rm $filename*

echo "> Téléchargement des fichiers compressés..."

wget http://files.data.gouv.fr/insee-sirene/$zip

echo ""
echo "> Extraction du fichier compressé..."

$unzip $zip

echo ""
echo "> Conversion du CSV établissement en RDF (N-triples)..."

time tarql -e UTF-8 --ntriples sparql/${type}2rdf.rq $csv > $nt

echo ""
echo "Deleting CSV in order to save space on my small disk..."

# rm $csv

echo ""
echo "> Conversion du RDF en HDT..."

time rdf2hdt $nt $hdt

echo ""
echo ">> Terminé"

done
