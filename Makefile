branch?="develop"
output?="nt"
root=`pwd`
rdfFile=sireneld.$(output)
rdf=$(root)/rdf/$(rdfFile)

hdt: rdf cleanHdt hdtOnly
	echo "Download + RDF + HDT".

hdtOnly:
	rdf=$(rdf) rdfFile=$(rdfFile) root=$(root) ./scripts/hdt.sh $(branch) $(server)

rdf: download cleanRdf rdfOnly concatRdf
	echo "Download + RDF."

concatRdf:
	cat rdf/*.gz > $(rdf).gz

rdfOnly:
	output=$(output) root=$(root) ./scripts/rdf.sh $(type)

download:
	root=$(root) ./scripts/download.sh

clean: cleanSource cleanRdf cleanHdt
	echo "Cleaned RDF, CSV and HDT..."

cleanSource:
	root=$(root) scripts/clean.sh sources

cleanRdf:
	root=$(root) scripts/clean.sh rdf

cleanHdt:
	root=$(root) scripts/clean.sh hdt

