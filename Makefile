branch?="develop"
output?="nt"
root=`pwd`
rdfFile=sireneld.$(output)
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
	root=$(root) ./scripts/download.sh

clean: cleanCsv cleanRdf cleanHdt
	echo "Cleaned RDF, CSV and HDT..."

cleanSource:
	root=$(root) scripts/clean.sh sources

cleanRdf:
	root=$(root) scripts/clean.sh rdf

cleanHdt:
	root=$(root) scripts/clean.sh hdt

