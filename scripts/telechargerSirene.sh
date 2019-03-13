#/bin/bash

date=`date +%Y-%m-%d`
heure=`date +%H:%M:%S`

tailleMax=$1

echo "Début du processus : $date $heure"

for type in "UniteLegale" "Etablissement"
do

    filename=Stock${type}_utf8
    zip=$filename.zip
    csv=$filename.csv
    unzip="unzip -o"

    if [[ -s $csv ]]; then

	echo "> $csv déjà présent : pas de téléchargement"
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
