home=`pwd`

hdt: rdf hdtOnly
	echo "Download + RDF + HDT".

hdtOnly:
	./scripts/hdt.sh $(branch) $(server)

rdf: download convertOnly
	echo "Download + RDF."

rdfOnly:
	./scripts/rdf.sh $(type)

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
