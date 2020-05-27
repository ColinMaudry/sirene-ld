#!/bin/bash

set -e

curl -sL https://sireneld.io/data/ontologies.tar.gz -o ontologies.tar.gz
tar -xzvf ontologies.tar.gz
rm ontologies.tar.gz



