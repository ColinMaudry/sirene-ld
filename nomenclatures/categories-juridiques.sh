#!/bin/bash
prefix="https://sireneld.io/vocab/sirecj#"
rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>"
rdfslabel="<http://www.w3.org/2000/01/rdf-schema#label>"
subClassOf="<http://www.w3.org/2000/01/rdf-schema#subClassOf>"

echo "" > categories-juridiques.nt

while IFS="£" read -r id label
do
    echo "<$prefix$id> $rdfslabel \"$label\"." >> categories-juridiques.nt

    if [[ ${#id} -gt 1 ]]
    then
        echo "<$prefix$id> $subClassOf <$prefix${id:0:1}>." >> categories-juridiques.nt
    fi
    if [[ ${#id} -gt 2 ]]
    then
        echo "<$prefix$id> $subClassOf <$prefix${id:0:2}>." >> categories-juridiques.nt
    fi

done < "categories-juridiques.tsv"




    # code=`echo "$line" | sed -E 's/([0-9]+)\t.*/$1/'`
    # label=`echo "$line" | sed -E 's/([0-9]+)\t(.*)/$2/'`
