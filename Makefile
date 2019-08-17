config ?= config.sh
include $(config)


publish: convert
	databasePath=$(DATABASEPATH) ./scripts/publish.sh

convert: convertEtablissementLight convertEtablissement convertUniteLegale
	echo "Conversion done."

convertEtablissement: download
	./scripts/convert.sh Etablissement full

convertEtablissementLight: download
	./scripts/convert.sh Etablissement light

convertUniteLegale: download
	./scripts/convert.sh UniteLegale full

download:
	departements=$(DEPARTEMENTS) ./scripts/download.sh

clean:
	rm -r csv rdf
