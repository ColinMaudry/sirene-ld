#!/bin/bash

source televersementConfig.sh

#Script to fetch daily data updates from the SIRENE API
# https://api.insee.fr/catalogue/site/themes/wso2/subthemes/insee/pages/item-info.jag?name=Sirene&version=V3&provider=insee

date=`date +%Y-%m-%d`

# Get the UniteLegale

curl -X GET --header 'Accept: text/csv' --header 'Authorization: $auth' 'https://api.insee.fr/entreprises/sirene/V3/siren?q=dateDernierTraitementUniteLegale%3A$date'

# Get the Etablissement

curl -X GET --header 'Accept: text/csv' --header 'Authorization: $auth' 'https://api.insee.fr/entreprises/sirene/V3/siret?q=dateDernierTraitementEtablissement%3A$date'
