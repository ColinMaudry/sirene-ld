branch?="develop"
output?="nt"
root=`pwd`
rdfFile=sireneld.$(output)
rdf=$(root)/rdf/$(rdfFile)

hdt: rdf cleanHdt hdtOnly

hdtOnly:
	rdf=$(rdf) rdfFile=$(rdfFile) root=$(root) ./scripts/hdt.sh $(branch) $(server)

rdf: download cleanRdf rdfOnly concatRdf

concatRdf:
	rm $(rdf).gz && cat rdf/*.gz > $(rdf).gz

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

