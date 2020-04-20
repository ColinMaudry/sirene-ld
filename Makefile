branch?="develop"
root=`pwd`
rdfFile="sireneld.nt"
rdf=$(root)/rdf/$(rdfFile)

hdt: rdf cleanHdt hdtOnly
	echo "Download + RDF + HDT".

hdtOnly:
	rdf=$(rdf) rdfFile=$(rdfFile) ./scripts/hdt.sh $(branch) $(server)

rdf: download cleanRdf rdfOnly zipRdf
	echo "Download + RDF."

zipRdf:
	gzip -f9 $(rdf)

rdfOnly:
	rdf=$(rdf) rdfFile=$(rdfFile) ./scripts/rdf.sh $(type)

download: 
	./scripts/download.sh

clean: cleanCsv cleanRdf cleanHdt
	echo "Cleaned RDF, CSV and HDT..."

cleanCsv:
	rm -rf csv

cleanRdf:
	rm -rf rdf

cleanHdt:
	rm -rf hdt

