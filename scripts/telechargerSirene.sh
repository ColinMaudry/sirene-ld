#/bin/bash

tailleMax=$1
types=("Etablissement" "UniteLegale")

for type in $types
do
    filename=Stock${type}_utf8
    zip=$filename.zip
    csv=$filename.csv
    unzip="unzip -o"

    if [[ -s $csv ]]; then
        ./scripts/convertirPublier.sh $csv $type $tailleMax
    else

        echo "> Téléchargement des fichiers compressés..."

        wget http://files.data.gouv.fr/insee-sirene/$zip

        echo ""
        echo "> Extraction du fichier compressé..."

        $unzip $zip

        ./scripts/convertirPublier.sh $csv $type $tailleMax
    fi

done
