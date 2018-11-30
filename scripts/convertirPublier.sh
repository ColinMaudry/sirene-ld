#!/bin/bash

csv=$1
type=$2

source ./scripts/televersementConfig.sh

if [[ -n $3 ]]; then
    maxChunkSize=$3
else
    maxChunkSize=25000
fi

nbTotalTriples=0


function transformPublish() {
    csvTemp=$1
    typeTemp=$2
    session=$3

    if [[ -n $session ]]; then
        nt=${csvTemp}_${session}.nt
    else
        nt=$csvTemp.nt
    fi

    echo ""
    echo "> Conversion du CSV $typeTemp en RDF vers $nt..."

    tarql -e UTF-8 --ntriples sparql/${typeTemp}2rdf.rq $csvTemp > $nt

    # The number of triples in the chunk
    triples=`cat $nt | wc -l`

    # Gzip the .nt, the .nt is deleted to save spac e
    gzip -f -9 $nt

    echo ""
    echo ">> Converti"

    nbTotalTriples=$((triples + nbTotalTriples))
    avgNbTriples=$((nbTotalTriples / (session + 1)))

    echo ""
    echo "ntSize:............$triples"
    echo "nbTotalTriples:....$nbTotalTriples"
    echo "avgNbTriples:......$avgNbTriples ($((session + 1)) sessions)"

    echo ""
    echo "Téléversement vers $repository..."

    curl -L --url "$repository" --data-binary @"$nt.gz" \
    -H "Content-type: application/n-triples" \
    -H "Content-encoding: gzip" \
    -H "Accept-asynchronous: notify" \
    -u $apikey:
}

echo "Comptage des lignes dans $csv..."
echo ""
nbLines=`cat $csv | wc -l`

# Number of actual records (lines, minus the header row)
nbRecords=$(( nbLines - 1 ))
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
        tail -n $nbRecords $csv | head -n $nbRecordsRemainder >> $csv.temp

        transformPublish "$csv.temp" $type "remainder_$nbRecordsRemainder"
    fi

    for (( c=1; c<=$nbChunksFloored; c++ ))
    do
        heure=`date +%H:%M:%S`

        echo ""
        echo "*************************************************"
        echo "$heure"
        echo "chunk: $c"

        tail=$((nbChunksRemaining * maxChunkSize))
        echo "lignes restantes: $tail"

        echo "Création du fichier CSV temporaire..."
        echo $header > $csv.temp
        tail -n $tail $csv | head -n $maxChunkSize >> $csv.temp

        transformPublish "$csv.temp" $type $c

        nbChunksRemaining=$((nbChunksRemaining - 1))

    done
else

    # The number of records is smaller than the max chunk size, no chunking
    transformPublish $csv $type
fi
