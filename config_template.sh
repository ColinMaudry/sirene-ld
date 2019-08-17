#!/bin/bash

# RDF output format.
# Possible values are
# ttl (Turtle, more compact)
# nt (N-Triples, more verbose but can be split on any line)
FORMAT=ttl

# List of INSEE departement codes for which the register data will be complete. The register data for the companies located in the other departements will be much lighter.
DEPARTEMENTS="35,29,56,22,75101,75102,75103,75104,75105,75106,75107,75108,75109,75110,75111,75112,75113,75114,75115,75116,75117,75118,75119,75120"

# The directory where you want tdb2.tdbloader create the database (see https://jena.apache.org/documentation/tdb2/tdb2_cmds.html)
DATABASEPATH="/home/joe/fuseki/run/databases/db"
