config ?= config.sh
include $(config)


publish: convert publishData publishVocab
	databasePath=$(DATABASEPATH) databaseSidecarPath=$(SIDECARBASEPATH) ./scripts/publish.sh

publishData:
	databasePath=$(DATABASEPATH) ./scripts/publish.sh data

publishVocab:
	databaseSidecarPath=$(SIDECARBASEPATH) ./scripts/publish.sh sidecar

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
