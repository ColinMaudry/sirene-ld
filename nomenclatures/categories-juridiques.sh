#!/bin/bash
prefix="https://sireneld.io/vocab/sirecj#"
rdftype="<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>"
rdfslabel="<http://www.w3.org/2000/01/rdf-schema#label>"
subClassOf="<http://www.w3.org/2000/01/rdf-schema#subClassOf>"


while IFS="£" read -r code label
do
    echo "<$prefix$code> $rdfslabel \"$label\"."

    if [[ ${#code} -gt 1 ]]
    then
        echo "<$prefix$code> $subClassOf <$prefix${code:0:1}>."
    fi
    if [[ ${#code} -gt 2 ]]
    then
        echo "<$prefix$code> $subClassOf <$prefix${code:0:2}>."
    fi

done < "catégories-juridiques.tsv"




    # code=`echo "$line" | sed -E 's/([0-9]+)\t.*/$1/'`
    # label=`echo "$line" | sed -E 's/([0-9]+)\t(.*)/$2/'`
