config ?= config.sh
include $(config)


publish: convert publishData publishVocab
	echo "Starting DB..." && eval $(STARTDB)

publishData: stopdb
	databasePath=$(DATABASEPATH) ./scripts/publish.sh data

publishVocab: stopdb
	databaseSidecarPath=$(SIDECARBASEPATH) ./scripts/publish.sh sidecar

stopdb:
	echo "Stopping DB and deleting data..." && eval $(STOPDB) && rm -rf $(DATABASEPATH) $(SIDECARBASEPATH)

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
