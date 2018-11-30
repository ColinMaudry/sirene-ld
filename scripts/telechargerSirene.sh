#/bin/bash

date=`date +%Y-%m-%d`
heure=`date +%H:%M:%S`

tailleMax=$1
types=("Etablissement" "UniteLegale")

echo "Début du processus : $date $heure"

for type in $types
do
    filename=Stock${type}_utf8
    zip=$filename.zip
    csv=$filename.csv
    unzip="unzip -o"

    if [[ -s $csv ]]; then
        time ./scripts/convertirPublier.sh $csv $type $tailleMax
    else

        echo "> Téléchargement des fichiers compressés..."

        wget http://files.data.gouv.fr/insee-sirene/$zip

        echo ""
        echo "> Extraction du fichier compressé..."

        $unzip $zip

        time ./scripts/convertirPublier.sh $csv $type $tailleMax
    fi

done

date=`date +%Y-%m-%d`
heure=`date +%H:%M:%S`

echo "Fin du processus : $date $heure"
