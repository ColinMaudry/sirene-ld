#!/bin/bash

csv=$1
type=$2

source ./scripts/televersementConfig.sh

if [[ "$target" -eq "hdt" ]]
then
    maxChunkSize=
elif [[ -n $3 ]]
then
    maxChunkSize=$3
else
    maxChunkSize=25000
fi

nbTotalTriples=0

function transformPublishRdf() {
    csvTemp=$1
    typeTemp=$2
    session=$3

    case $target in

        hdt)
        if [[ ! -z $graphBaseUri ]]; then
            ext=trig
        else
            ext=ttl
        fi
        rdf=$csvTemp.$ext
        rdfFormat=
        ;;

        *)
        ext=nt
        rdfFormat="--ntriples"

        if [[ -n $session ]]; then
            rdf=${csvTemp}_${session}.$ext
        else
            rdf=$csvTemp.$ext
        fi
        ;;
    esac

    if [[ ! -f $rdf ]]
    then

        tarqlCmd="tarql -e UTF-8 $rdfFormat sparql/${typeTemp}2rdf.rq $csvTemp"

        case $ext in

            trig)
                graphname="<${graphBaseUri}$typeTemp>"

                # Récupération des déclarations de préfixes et création d'un header
                grep "PREFIX" sparql/${typeTemp}2rdf.rq | sed "s/PREFIX/@prefix/" | sed -r "s/(.*)/\1 ./" > $rdf

                # Ajout du nom de graphe
                echo -e "\n$graphname {" >> $rdf

                # Conversion streamée vers RDF en omettant les déclarations de préfixes
                echo ""
                echo "> Conversion du CSV $typeTemp en RDF vers $rdf (graphe : $graphname)..."
                time $tarqlCmd | grep -v '^@' >> $rdf

                # Clôture du graphe
                echo "}" >> $rdf

            ;;
            *)
                # Conversion streamée vers RDF
                echo ""
                echo "> Conversion du CSV $typeTemp en RDF vers $rdf..."
                time $tarqlCmd > $rdf
            ;;
        esac
    else
        echo "Fichier RDF déjà présent, pas de transformation."
    fi

    if [[ ! -f $rdf.hdt ]]
    then
        case $target in
            triplestore)
                publishToTriplestore $rdf
                rm $rdf
            ;;

            hdt)
                convertToHdt $rdf
            ;;
        esac
    fi

}

function publishToTriplestore () {
    rdf=$1

    # The number of triples in the chunk
    triples=`cat $rdf | wc -l`
    #If it's Dydra, gzip the .nt, the .nt is deleted to save space
    if [[ $repository = *"dydra"* ]]; then
        gzip -f -9 $rdf

        curlOptions= --data-binary @"./$rdf.gz" -H "Content-type: application/n-triples" -H "Content-encoding: gzip" -H "Accept-asynchronous: notify" -u $apikey:
    else
        curlOptions=' --data-binary @./$rdf -H "Content-type: application/n-triples" -u $user:$apikey'

    fi

    repositoryWithGraph=${repository}?graph=urn%3Asireneld%3Asirene%3A$type

    echo ""
    echo ">> Converti"

    nbTotalTriples=$((triples + nbTotalTriples))
    avgNbTriples=$((nbTotalTriples / (session + 1)))

    echo ""
    echo "ntSize:............$triples"
    echo "nbTotalTriples:....$nbTotalTriples"
    echo "avgNbTriples:......$avgNbTriples ($((session + 1)) sessions)"

    echo ""
    echo "Téléversement vers $repositoryWithGraph..."

    curl -v --url "$repositoryWithGraph" --data-binary @./$rdf -H "Content-type: application/n-triples" -u $user:$apikey
}

function processCsv () {
    csv=$1

    echo "Comptage des lignes dans $csv..."
    echo ""
    nbLines=`cat $csv | wc -l`
    echo $nbLines

    # Number of actual records (lines, minus the header row)
    nbRecords=$(( nbLines - 1 ))
    halfTotal=$(( nbRecords / 2 ))
    header=`head -n 1 $csv`

    if [[ -n $maxChunkSize && $nbRecords -gt $maxChunkSize ]]; then
        # The number of records is bigger than the max chunk size, we must split the file

        # Number of chunks with max size
        nbChunksFloored=$(( nbRecords / maxChunkSize ))

        # Records remaining from the division
        nbRecordsRemainder=$(( nbRecords % maxChunkSize ))

        # Number of chunks to be processed
        nbChunksRemaining=$nbChunksFloored

        echo "nbRecords: $nbRecords nbChunksFloored: $nbChunksFloored nbRecordsRemainder: $nbRecordsRemainder"

        if [[ $nbRecordsRemainder -gt 0 ]]; then
            echo $header > $csv.temp

            echo "Création du fichier d'enregistrements restants (remainder)..."
            echo ""
            head -n $(($nbRecordsRemainder + 1)) $csv | tail -n $nbRecordsRemainder >> $csv.temp

            transformPublishRdf "$csv.temp" $type "remainder_$nbRecordsRemainder"
        fi

        for (( c=1; c<=$nbChunksFloored; c++ ))
        do
            heure=`date +%H:%M:%S`

            echo ""
            echo "*************************************************"
            echo "$heure"
            echo "chunk: $c"
            echo ""

            processedRecords=$((((c - 1) * maxChunkSize) + nbRecordsRemainder))
            remainingRecords=$((nbChunksRemaining * maxChunkSize))

            echo "lignes traitées:......$processedRecords"
            echo "lignes restantes:.....$remainingRecords"
            echo ""

            echo "Création du fichier CSV temporaire..."

            echo $header > $csv.temp

            # If less than half of the records remain to be processed, tail is faster than head
            if [[ $remainingRecords -lt $halfTotal ]]; then
                tail -n $remainingRecords $csv | head -n $maxChunkSize >> $csv.temp
            else
                head -n $(($processedRecords + 1)) $csv | tail -n $maxChunkSize >> $csv.temp
            fi

            transformPublishRdf "$csv.temp" $type $c

            nbChunksRemaining=$((nbChunksRemaining - 1))

        done
    else

        # The number of records is smaller than the max chunk size, no chunking
        transformPublishRdf $csv $type
    fi
}

function convertToHdt () {
    rdf=$1

    rm $rdf.hdt.index.v1-1
    rdf2hdt -i -f turtle -p $rdf $rdf.hdt
}

function reduceData() {

    col=$1
    colPreserved=$2
    keyvalue=$3

    echo $type $colPreserved $col $keyvalue

    echo "Extraction des colonnes d'intérêt pour les $type inactifs vers $inactivecsv.temp..."
    time csvcut -d "," -c $colPreserved $csv > $inactivecsv.temp

    echo "Extraction des $type inactifs vers $inactivecsv..."
    head -n 1 $inactivecsv.temp > $inactivecsv
    time awk -F, -v val=$keyvalue '$2 ~ val {print}' $inactivecsv.temp >> $inactivecsv
    rm $inactivecsv.temp

    echo "Extraction des $type actifs vers $activecsv..."
    head -n 1 $csv > $activecsv
    awk -F, -v col=$col '$col ~ /A/ {print}' $csv >> $activecsv

    for csv in $activecsv $inactivecsv
    do
        processCsv $csv
    done

}

if [[ "$lightdata" -eq "yes" && ! "$target" -eq "hdt" ]]
then

    activecsv=Stock${type}_utf8_active.csv
    inactivecsv=Stock${type}_utf8_inactive.csv

case $type in

    UniteLegale)
    #Numéro de la colonne contenant l'état administratif
    col=`awk -v RS=, '/etatadministratifunitelegale/{print NR; exit}' $csv`

    # Les colonnes que l'on souhaite conserver pour les inactifs
    colPreserved="siren,etatadministratifunitelegale,nomunitelegale,denominationunitelegale"
    echo $type $colPreserved

    # La valeur de l'état administratif pour les éléments inactifs
    keyvalue=C

    reduceData $col $colPreserved $keyvalue
    ;;

    Etablissement)
    # Numéro de la colonne contenant l'état administratif
    col=`awk -v RS=, '/etatadministratifetablissement/{print NR; exit}' $csv`

    # Les colonnes que l'on souhaite conserver pour les inactifs
    colPreserved="siren,etatadministratifetablissement,nic,siret"
    echo $type $colPreserved

    # La valeur de l'état administratif pour les éléments inactifs
    keyvalue=F

    reduceData $col $colPreserved $keyvalue
    ;;
esac

else
    processCsv $csv
fi
