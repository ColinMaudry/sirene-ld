#!/bin/bash

# fail on error
set -e

source config.sh

case $1 in

    data)

rdfs=`ls rdf/*`

echo "Loading SIRENE data..."
time tdb2.tdbloader -v --loc $databasePath --loader "phased" $rdfs
    ;;

    sidecar)

nomenclaturesNt=`ls nomenclatures/*.nt`
nomenclaturesTtl=`ls nomenclatures/*.ttl`
ontologies=`ls ontologies/*.ttl`

echo "Loading ontology and reference data..."
time tdb2.tdbloader -v --loc $databaseSidecarPath --loader "parallel" $nomenclaturesNt $nomenclaturesTtl

    ;;

esac
