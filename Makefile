config ?= config/config.sh
include $(config)
home=`pwd`

convert: download convertOnly
	echo "Conversion done."

convertOnly:
	./scripts/rdf.sh $type

download:
	departements=$(DEPARTEMENTS) ./scripts/download.sh

clean: cleanCsv cleanRdf cleanHdt
	echo "Cleaned RDF, CSV and HDT..."

cleanCsv:
	rm -rf csv

cleanRdf:
	rm -rf rdf

cleanHdt:
	rm -rf hdt
