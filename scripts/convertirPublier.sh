#!/bin/bash

csv=$1
type=$2

source ./scripts/televersementConfig.sh

if [[ -n $3 ]]; then
    maxChunkSize=$3
else
    maxChunkSize=50000
fi


function transformPublish() {
    csvTemp=$1
    typeTemp=$2

    if [[ -n $3 ]]; then
        nt=${csvTemp}_${3}.nt
    else
        nt=$csvTemp.nt
    fi

    echo ""
    echo "> Conversion du CSV $typeTemp en RDF vers $nt..."

    time tarql -e UTF-8 --ntriples sparql/${typeTemp}2rdf.rq $csvTemp > $nt

    echo ""
    echo ">> Converti"

    ntSize=`cat $nt | wc -l`
    echo ""
    echo "ntSize: $ntSize triples"

    echo ""
    echo "Téléversement vers $repository..."

    curl -vL --url "$repository" --data-binary @"$nt" \
    -H "Content-type: application/n-triples" \
    -H "Accept-asynchronous: notify" \
    -u $apikey:
}

nbLines=`cat $csv | wc -l`

# Number of actual records (lines, minus the header row)
nbRecords=$(( nbLines - 1 ))

header=`head -n 1 $csv`

echo "nbRecords: $nbRecords"
echo "header: $header"

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
        tail -n $nbRecords $csv | head -n $nbRecordsRemainder >> $csv.temp

        transformPublish "$csv.temp" $type "remainder_$nbRecordsRemainder"
    fi

    for (( c=1; c<=$nbChunksFloored; c++ ))
    do
        echo ""
        echo "*************************************************"
        echo ""
        echo "chunk: $c"

        tail=$((nbChunksRemaining * maxChunkSize))
        echo "lignes restantes: $tail"

        echo $header > $csv.temp
        tail -n $tail $csv | head -n $maxChunkSize >> $csv.temp

        transformPublish "$csv.temp" $type $c

        nbChunksRemaining=$((nbChunksRemaining - 1))

    done
else

    # The number of records is smaller than the max chunk size, no chunking
    transformPublish $csv $type
fi
