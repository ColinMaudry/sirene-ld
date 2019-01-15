#/bin/bash

date=`date +%Y-%m-%d`
heure=`date +%H:%M:%S`

tailleMax=$1
declare -a types=("Etablissement" "UniteLegale")
echo $types

echo "Début du processus : $date $heure"

for type in "UniteLegale" "Etablissement"
do

    filename=Stock${type}_utf8
    zip=$filename.zip
    csv=$filename.csv
    unzip="unzip -o"

    if [[ -s $csv ]]; then

	echo "> $csv déjà présent"
        time ./scripts/convertirPublier.sh $csv $type $tailleMax
    else

        echo "> Téléchargement de $zip..."

        wget http://files.data.gouv.fr/insee-sirene/$zip

        echo ""
        echo "> Extraction de $zip..."

        $unzip $zip

        time ./scripts/convertirPublier.sh $csv $type $tailleMax
    fi

done

date=`date +%Y-%m-%d`
heure=`date +%H:%M:%S`

echo "Fin du processus : $date $heure"
