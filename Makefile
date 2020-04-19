branch?="develop"
root=`pwd`

hdt: rdf cleanHdt hdtOnly
	echo "Download + RDF + HDT".

hdtOnly:
	./scripts/hdt.sh $(branch) $(server)

rdf: download cleanRdf rdfOnly zipRdf
	echo "Download + RDF."

zipRdf:
	cd rdf && gzip -f -9 sireneld.trig

rdfOnly:
	./scripts/rdf.sh $(type)

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

