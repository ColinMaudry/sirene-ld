#!/bin/bash

csv=$1
type=$2
ext=nt
rdf="$csv.$ext"


echo "csv:	$csv"
echo "rdf:	$rdf"
echo "ext:	$ext"
echo "type:	$type"

if [[ $ext -eq "nt" ]]
then
	format="--ntriples"
    header=`head -n 1 $csv`

    tail -n +2 $csv > ${csv}_headless
    split -n l/4 --additional-suffix=".temp" ${csv}_headless ${csv}_headless_
    rm ${csv}_headless

    for file in `ls ${csv}_headless_*`
    do
        temp=${file}_headful.temp
        echo $header > $temp
        cat $file >> $temp
        time tarql $format -e UTF-8  sparql/full${type}2rdf.rq $temp > $file.nt &
        echo "$file processing in parrallel..."
    done
fi

wait
echo "Done parrallel processing."

rm *.temp

rm $rdf
cat *.nt > $rdf

echo ""
time rdf2hdt -i -f $ext $rdf  $rdf.hdt

rm *.temp.$ext

ls -lh $rdf
ls -lh $rdf.hdt
