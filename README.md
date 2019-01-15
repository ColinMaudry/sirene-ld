# SIRENE LD 1.0.0

Transformation du répertoire SIRENE (CSV) au format RDF pour publication en [Linked Data](https://fr.wikipedia.org/wiki/Web_des_donn%C3%A9es#Principes).

## Données sources

Le CSV source provient du fichier SIRENE géo-taggé et publié par [@cquest](https://github.com/cquest) et disponible ici : http://data.cquest.org/geo_sirene/last/.

La source ouverte officielle est [le jeu de données publié sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/).

## Pourquoi tu fais ça ?

Je pense que des entités aussi cruciales que les entreprises doivent avoir des identifiants ancrés dans le Web, des URI.

Ainsi, en suivant les principes du [Linked Data](https://fr.wikipedia.org/wiki/Web_des_donn%C3%A9es#Principes), ces URI

- servent d'identifiants universels (`81223113200026` est ambigu sans contexte, `https://sireneld.io/siret/81223113200026` est sans équivoque)
- l'ancrage dans le Web permet une clarification de la responsabilité (il suffit d'ouvrir [sireneld.io](https://sireneld.io) pour savoir qui contrôle les URI basées sur ce domaine)
- ces identifiants retournent une description de l'entité, sous forme de données (JSON, XML, ...) ou de HTML (pour les humains) en fonction de l'en-tête `Accept-Type` envoyé dans le requête HTTP GET
- bonus : les données de cette entité contiennent des paramètres sous forme d'URI, et des références d'autres entités identifiées par des URI, que vous pouvez également interroger, qui elles mêmes retournent des URI, etc.

Si vous souhaitez en savoir plus sur le Linked Data, je vous conseille chaudement la lecture du [Linked Data book](http://linkeddatabook.com/editions/1.0/), par Christian Bizer et Tom Heath (en anglais).


## Objectifs et étapes de transformation

| Fait  | Description                                                                                                                                                                                                                                                                                                                                                                                                                                               | Progression                                                                                                                        |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| **✓** | Transformer les données CSV au format [RDF](https://fr.wikipedia.org/wiki/Resource_Description_Framework), dans la sérialisation Turtle, en utilisant [Tarql](https://github.com/tarql/tarql) et une [requête SPARQL](https://fr.wikipedia.org/wiki/SPARQL) de type `CONSTRUCT` ([csv2rdf.rq](https://github.com/ColinMaudry/sirene-ld/blob/master/sparql/csv2rdf.rq)).<br/>[Résultat](https://github.com/ColinMaudry/sirene-ld/tree/master/échantillons) | [transform](https://github.com/ColinMaudry/sirene-ld/labels/transform)                                                             |
| **✓** | Charger les données dans un [triple store](https://fr.wikipedia.org/wiki/Triplestore), une base données dédiée au stockage et au requêtages de triplets RDF ([GraphDB Free](https://ontotext.com/products/graphdb/editions/) ou [Apache Fuseki](http://jena.apache.org/documentation/fuseki2/))<br/>[Résultat](https://sireneld.io/presentation#sparql).                                                                                                                                                          | [triplestore](https://github.com/ColinMaudry/sirene-ld/labels/triplestore)                                                         |
| **✓** | Créer et publier une ou plusieurs ontologies pour définir les classes et propriétés des entreprises et établissements décrits dans les données du SIRENE.<br/>[Résultat](https://github.com/ColinMaudry/sirene-ld/tree/master/ontologies)                                                                                                                                                                                                                  | [ontology](https://github.com/ColinMaudry/sirene-ld/labels/ontology)                                                               |
|       | Développer une application Web où les données seront visibles et mises en valeur (en cours : [sireneld.io](https://sireneld.io) ([source](https://github.com/colinMaudry/sirene-ld-web))                                                                                                                                                                 | api \| [frontend](https://github.com/ColinMaudry/sirene-ld-web/issues) |
|       | Intégrer automatiquement les mises à jour quotidiennes publiées par l'INSEE et [géocodées par @cquest](http://data.cquest.org/geo_sirene/quotidien/).                                                                                                                                                                                                                                                                                                     | [data-update](https://github.com/ColinMaudry/sirene-ld/labels/data-update)                                                         |
|       | Enrichir les données à partir d'autres sources de données ouvertes (RNA, DECP, RNCS, RM, etc.) externes.                                                                                                                                                                                                                                                                                                                                         | [enrich](https://github.com/ColinMaudry/sirene-ld/labels/enrich)                                                                   |
|       | Publier les données sous forme de [Linked Data Fragments](http://linkeddatafragments.org/) pour streamer les résultats de requêtes SPARQL.                                                                                                                                                                                                                                                                                                                | [ldf](https://github.com/ColinMaudry/sirene-ld/labels/ldf)                                                                         |
|       | Intégrer le tout au [Service public de la donnée](https://www.data.gouv.fr/fr/reference) (chiche !?)                                                                                                                                                                                                                                                                                                                                                      |                                                                                                                                    |

- Vous trouverez des échantillons de données (CSV source et résultats de transformation) dans `[échantillons](https://github.com/ColinMaudry/sirene-ld/tree/master/échantillons)`


## Notes de version

*1.0.0* (15 janvier 2019)

- conversion du SIRENE vers RDF
- ontologies
- chargement dans le triple store par fragments

## Soutien

Je compte consacrer pas mal de temps à ce projet et je devrai louer un serveur dédié afin de traiter, héberger et publier la masse de données que représente le SIRENE une fois transformé en graphe (en moyenne 500 Mo par département), sans compter les données périphériques (codes officiels géographiques, nomenclature NAF, etc.).

Ainsi, pour soutenir ce projet vous pouvez :

- ajouter une étoile dans Github (en haut à droite de l'écran)
- retweeter les tweets qui ont [le hashtag #sireneLD](https://twitter.com/hashtag/sireneLD?f=tweets)
- m'envoyer vos commentaires et encouragements par email ([colin@maudry.com](mailto:colin@maudry.com))
