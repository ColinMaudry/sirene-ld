#!/bin/bash

# fail on error
set -e

source config.sh

rdfs=`ls rdf/*`

time tdb2.tdbloader -v --loc $databasePath --loader "sequential" $rdfs
