# SIRENE LD 1.2.0

Transformation du répertoire SIRENE (CSV) et données connexes au format RDF pour publication en [Linked Data](https://fr.wikipedia.org/wiki/Web_des_donn%C3%A9es#Principes).

Le projet est en chantier total, mais quand il y a du nouveau, c'est sur [sireneld.io](https://sireneld.io) et sur Twitter via le hashtag [#sireneLD](https://twitter.com/hashtag/sireneld).

## Données sources

### SIRENE

Le [répertoire SIRENE](http://www.sirene.fr/sirene/public/static/contenu-base-sirene) est administré et publié par l'[INSEE](https://www.insee.fr) et rassemble de nombreuses informations sur les organisations publiques (collectivités, administrations centrales) et privées (à but lucratif ou non-lucratif).

Chaque organisation est composée :

- d'une **unité légale** : l'unité légale rassemble toutes les informations centrales sur l'entreprise, indistinctement de son emplacement géographique.
- d'un ou plusieurs **établissements** : chaque établissement correspond à un lieu rattaché à l'entreprise, avec une adresse, une enseigne, un type d'activité, un nombre d'employés (par tranches), etc.

Le CSV source des établissements provient du fichier SIRENE géo-taggé et publié par [@cquest](https://github.com/cquest) et disponible ici : http://data.cquest.org/geo_sirene/v2019/last/.

La source ouverte officielle est [le jeu de données publié sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/). C'est également depuis ce jeu de données que sireneLD récupère les données des unité légales.

### Données connexes

Les identifiants SIREN et SIRET sont les identifiants les plus courants pour identifier une organisation française. Ils sont donc logiquement présents dans des données qui décrivent leur activité. L'un des objectif de ce projet est de publier également ces données connexes, pour qu'elles ne forme un ensemble lié et requêtable.

La liste complète et à jour est [là](https://github.com/ColinMaudry/sirene-ld/issues?q=is%3Aopen+is%3Aissue+label%3Aenrich).

Quelques exemples, par ordre d'intégration :

- attributions de marchés publics (DECP)
- données des greffes (RNCS)
- données spécifiques aux associations (RNA)

## Pourquoi tu fais ça ?

Je pense que des entités aussi cruciales que les entreprises et les organismes publics doivent avoir des identifiants ancrés dans le Web, des URI. Cela vaut aussi pour les données périphériques, tels que les marchés publics. Je pense aussi que l'accessibilité de ces données est insuffisant compte tenu de leur importance.

Ainsi, en suivant les principes du [Linked Data](https://fr.wikipedia.org/wiki/Web_des_donn%C3%A9es#Principes), ces URI

- servent d'identifiants universels (`81223113200034` est ambigu sans contexte, `https://sireneld.io/siret/81223113200034` est univoque)
- l'ancrage dans le Web permet une clarification de la responsabilité (il suffit d'ouvrir [sireneld.io](https://sireneld.io) pour savoir qui contrôle les URI basées sur ce domaine)
- ces identifiants retournent une description de l'entité, sous forme de données (JSON, XML, ...) ou de HTML (pour les humains) en fonction de l'en-tête `Accept-Type` envoyé dans le requête HTTP GET
- bonus : les données de cette entité contiennent des paramètres sous forme d'URI, et des références d'autres entités identifiées par des URI, que vous pouvez également interroger, qui elles mêmes retournent des URI, etc.

Si vous souhaitez en savoir plus sur le Linked Data, j'ai créé une liste de recommandations de lecture en bas de [la page d'accueil de mon site Web](https://colin.maudry.fr).

Le second objectif est de proposer une interface graphique et une API permettant le requêtage des données.

## Objectifs et étapes de transformation

| Fait  | Description                                                                                                                                                                                                                                                                                                                                                                                                                                               | Progression                                                                                                                        |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| **✓** | Transformer les données CSV au format [RDF](https://fr.wikipedia.org/wiki/Resource_Description_Framework), en utilisant [Tarql](https://github.com/tarql/tarql) et une [requête SPARQL](https://fr.wikipedia.org/wiki/SPARQL) de type `CONSTRUCT` ([Etablissement2rdf.rq](https://github.com/ColinMaudry/sirene-ld/blob/master/sparql/Etablissement2rdf.rq) et [UniteLegale2rdf.rq](https://github.com/ ColinMaudry/sirene-ld/blob/master/sparql/UniteLegale2rdf.rq)).<br/>[Résultat](https://github.com/ColinMaudry/sirene-ld/tree/master/echantillons).<br/>Pour un requêtage efficace et pour remplacer le triple store, la production d'une archive HDT est également nécessaire.| [transform](https://github.com/ColinMaudry/sirene-ld/labels/transform)                                                             |
| Abandonné | Charger les données dans un [triple store](https://fr.wikipedia.org/wiki/Triplestore), une base données dédiée au stockage et au requêtages de triplets RDF ([GraphDB Free](https://ontotext.com/products/graphdb/editions/) ou [Apache Fuseki](http://jena.apache.org/documentation/fuseki2/))<br/>[Résultat](https://sireneld.io/presentation#sparql).                                                                                                                                                          | [triplestore](https://github.com/ColinMaudry/sirene-ld/labels/triplestore)                                                         |
|    | Exposer l'archive HDT à traver un point de requête SPARQL via le [Comunica HDT SPARQL actor](https://github.com/comunica/comunica-actor-init-sparql-hdt#usage-as-a-sparql-endpoint) pour des requêtes SPARQL résilientes.                                                | [ldf](https://github.com/ColinMaudry/sirene-ld/labels/ldf)
| **✓** | Créer et publier une ou plusieurs ontologies pour définir les classes et propriétés des entreprises et établissements décrits dans les données du SIRENE.<br/>[Résultat](https://github.com/ColinMaudry/sirene-ld/tree/master/ontologies)                                                                                                                                                                                                                  | [ontology](https://github.com/ColinMaudry/sirene-ld/labels/ontology)                                                               |
|       | Développer une application Web où les données seront visibles et mises en valeur (en cours : [sireneld.io](https://sireneld.io) ([source](https://github.com/colinMaudry/sirene-ld-web))                                                                                                                                                                 | api \| [frontend](https://github.com/ColinMaudry/sirene-ld-web/issues) |
|       | Intégrer automatiquement les mises à jour quotidiennes publiées par l'INSEE et [géocodées par @cquest](http://data.cquest.org/geo_sirene/quotidien/).                                                                                                                                                                                                                                                                                                     | [data-update](https://github.com/ColinMaudry/sirene-ld/labels/data-update)                                                         |
|       | Enrichir les données à partir d'autres sources de données ouvertes ([marchés publics](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9/), RNA, RNCS, etc.) externes.                                                                                                                                                                                                                                                                                                                                         | [enrich](https://github.com/ColinMaudry/sirene-ld/labels/enrich)                                                                   |
|       | Intégrer le tout au [Service public de la donnée](https://www.data.gouv.fr/fr/reference) (chiche !?)                                                                                                                                                                                                                                                                                                                                                      |                                                                                                                                    |

## Notes de version

*1.2.0* (23 avril 2020)

- adoption du format binaire HDT ([Header, Dictionary, Triples](http://www.rdfhdt.org/what-is-hdt/)) pour la publication des données
- adoption des requêtes SPARQL à la structure 2019 du SIRENE
- utilisation d'un serveur temporaire pour la création du fichier HDT

*1.1.0* (15 janvier 2019)

- suppression des .nt téléversés pour économiser de l'espace disque

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
