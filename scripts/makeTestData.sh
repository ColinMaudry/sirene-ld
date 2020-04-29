#!/bin/bash

if [[ ! -d testdata ]]
then
mkdir testdata
fi

head -n 1 csv/Etablissement/StockEtablissement_utf8_geo.csv > testdata/etablissements.csv
grep "812231132"  csv/Etablissement/StockEtablissementActif_utf8_geo.csv >> testdata/etablissements.csv

head -n 1 csv/UniteLegale/StockUniteLegale_utf8.csv > testdata/unitelegale.csv
grep "812231132"  csv/UniteLegale/StockUniteLegale_utf8.csv >> testdata/unitelegale.csv

tarql --ntriples sparql/UniteLegale2rdf.rq testdata/unitelegale.csv  | sed 's/\.$/ <urn:graphs:unitelegale}>./'> testdata/unitelegale.nt
tarql --ntriples sparql/Etablissement2rdf.rq testdata/etablissements.csv | sed 's/\.$/ <urn:graphs:etablissement>./' > testdata/etablissements.nt

rdf2rdf -in ontologies/sirext.ttl -out ontologies/sirext.nt
rdf2rdf -in nomenclatures/departements.ttl -out nomenclatures/departements.nt
rdf2rdf -in nomenclatures/divers.ttl -out nomenclatures/divers.nt
rdf2rdf -in nomenclatures/regions.ttl -out nomenclatures/regions.nt

cat ontologies/*.nt > testdata/ontologies.nt
cat nomenclatures/*.nt > testdata/nomenclatures.nt

cat testdata/*.nt > testdata/sireneld.nt
rdf2hdt -i -f nt testdata/sireneld.nt testdata/sireneld.hdt
