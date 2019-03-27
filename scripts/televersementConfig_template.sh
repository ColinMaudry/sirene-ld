
# URL of the target repository
repository=

# User name (empty for Dydra)
user=

# Repo password or Dydra API Key
apikey=

# INSEE API key (pas utilisé pour l'instant)
# inseekey="Bearer xxxxx"

# Réduire considérablement les données sur les établissements et unités légales fermés/inactives ? (par exemple pour économiser de l'espace)
# Mettre à yes pour l'activer
lightdata=no

# Cible de la transformation RDF : stocker dans un triple store ou bien produire un fichier HDT
# target=hdt :
#- désactive le chunking (la division du CSV source en morceaux de n lignes)

target=triplestore
graphBaseUri=urn:graph:sirene:
