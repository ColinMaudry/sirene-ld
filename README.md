# SIRENE LD

Transformation du répertoire SIRENE (CSV) au format RDF pour publication en [Linked Data](https://fr.wikipedia.org/wiki/Web_des_donn%C3%A9es#Principes).

## Données sources

Le CSV source provient du fichier SIRENE géo-taggé et publié par @cquest et disponible ici : http://data.cquest.org/geo_sirene/last/.

La source ouverte officielle est [le jeu de données publié sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/).

## Pourquoi tu fais ça ?

Je pense que des entités aussi cruciales que les entreprises doivent avoir des identifiants ancrés dans le Web, des URI.

Ainsi, en suivant les principes du [Linked Data](https://fr.wikipedia.org/wiki/Web_des_donn%C3%A9es#Principes), ces URI

- servent d'identifiants universels (`81223113200026` est ambigu sans contexte, `https://sireneld.io/siret/81223113200026` est sans équivoque)
- l'ancrage dans le Web permet une clarification de la responsabilité (il suffit d'ouvrir [sireneld.io](https://sireneld.io) pour savoir qui contrôle ces URI)
- ces identifiants retournent une description de l'entité, sous forme de données (JSON, XML, ...) ou de HTML (pour les humains) en fonction de l'en-tête `Accept-Type` envoyé dans le requête HTTP GET
- bonus : la description de cette entité contient des paramètres sous forme d'URI, et des références d'autres entités identifiées par des URI, pour une vraie sérandipité du Web

Si vous souhaitez en savoir plus sur le Linked Data, je vous conseille chaudement la lecture du Linked Data book, par Christian Bizer et Tom Heath (en anglais)


## Objectifs et étapes de transformation

| Fait  | Description                                                                                                                                                                                                                                                                                                                                                             | Progression                                                                                                                     |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **✓** | Transformer les données CSV au format [RDF](https://fr.wikipedia.org/wiki/Resource_Description_Framework), dans la sérialisation Turtle, en utilisant [Tarql](https://github.com/tarql/tarql) et une [requête SPARQL](https://fr.wikipedia.org/wiki/SPARQL) de type `CONSTRUCT` ([csv2rdf.rq](https://github.com/ColinMaudry/sirene-ld/blob/master/sparql/csv2rdf.rq)). | [transform](https://github.com/ColinMaudry/sirene-ld/labels/transform)                                                          |
|       | Charger les données dans un [triple store](https://fr.wikipedia.org/wiki/Triplestore), une base données dédiée au stockage et au requếtages de triplets RDF ([GraphDB Free](https://ontotext.com/products/graphdb/editions/) ou [Stardog Community](https://www.stardog.com/)).                                                                                         | [triplestore](https://github.com/ColinMaudry/sirene-ld/labels/triplestore)                                                      |
|       | Publier les données, probablement en utilisant [Elda](http://epimorphics.github.io/elda/current/index.html) (voir [SIRENE LD Web](https://github.com/ColinMaudry/sirene-ld-web))   <ul><li>API REST riche et multiformats (JSON-LD, RDF/XML, Turtle, CSV)</li><li>Interface Web</li></ul>                                                                               | [api](https://github.com/ColinMaudry/sirene-ld/labels/api) \| [frontend](https://github.com/ColinMaudry/sirene-ld/labels/frontend) |
|       | Intégrer automatiquement les mises à jour quotidiennes publiées par l'INSEE et [géocodées par @cquest](http://data.cquest.org/geo_sirene/quotidien/).                                                                                                                                                                                                                   | [data-update](https://github.com/ColinMaudry/sirene-ld/labels/data-update)                                                      |
|       | Enrichir les données à partir de [DBPedia](https://fr.wikipedia.org/wiki/DBpedia) et d'autres sources externes.                                                                                                                                                                                                                                                         | [enrich](https://github.com/ColinMaudry/sirene-ld/labels/enrich)                                                                |
|       | Publier les données en [Linked Data Fragments](http://linkeddatafragments.org/) pour streamer les résultats de requêtes SPARQL.                                                                                                                                                                                                                                         | [ldf](https://github.com/ColinMaudry/sirene-ld/labels/ldf)                                                                                                                                |
|       | Intégrer le tout au [Service public de la donnée](https://www.data.gouv.fr/fr/reference) (chiche !?)                                                                                                                                                                                                                                                                    |                                                                                                                                 |

- Vous trouverez des échantillons de données (CSV source et résultats de transformation) dans `[échantillons](https://github.com/ColinMaudry/sirene-ld/tree/master/échantillons)`


## Domaines et structure des URI

## Suivi du traitement des champs

Les champs de la base SIRENE sont documentés dans [dessin_L2_description_complete.pdf](https://github.com/ColinMaudry/sirene-ld/blob/master/dessin_L2_description_complete.pdf).

| Champ                       | Conversion ? | Commentaire |
| --------------------------- | ------------ | ----------- |
| SIREN                       | Oui          |             |
| NIC                         | Oui          |             |
| L1_NORMALISE                | Oui          |             |
| L2_NORMALISE                | Oui          |             |
| L3_NORMALISE                | Oui          |             |
| L4_NORMALISE                | Oui          |             |
| L5_NORMALISE                | Oui          |             |
| L6_NORMALISE                | Oui          |             |
| L7_NORMALISE                | Oui          |             |
| L1_DECLAREE                 | Oui          |             |
| L2_DECLAREE                 | Oui          |             |
| L3_DECLAREE                 | Oui          |             |
| L4_DECLAREE                 | Oui          |             |
| L5_DECLAREE                 | Oui          |             |
| L6_DECLAREE                 | Oui          |             |
| L7_DECLAREE                 | Oui          |             |
| NUMVOIE                     | Oui          |             |
| INDREP                      | Oui          |             |
| TYPVOIE                     | Oui          |             |
| LIBVOIE                     | Oui          |             |
| CODEPOS                     | Oui          |             |
| CEDEX                       | Oui          |             |
| DEPET                       | Oui          |             |
| COMET                       | Oui          |             |
| TCD                         | Oui          |             |
| SIEGE                       | Oui          |             |
| ENSEIGNE                    | Oui          |             |
| IND_PUBLIPO                 | Oui          |             |
| DIFFCOM                     | Oui          |             |
| AMINTRET                    | Oui          |             |
| NATETAB                     | Oui          |             |
| APET700                     | Oui          |             |
| TEFET                       | Oui          |             |
| EFETCENT                    | Oui          |             |
| DEFET                       | Oui          |             |
| ORIGINE                     | Oui          |             |
| DCRET                       | Oui          |             |
| DDEBACT                     | Oui          |             |
| ACTIVNAT                    | Oui          |             |
| LIEUACT                     | Oui          |             |
| ACTISURF                    | Oui          |             |
| SAISONAT                    | Oui          |             |
| MODET                       | Oui          |             |
| PRODET                      | Oui          |             |
| PRODPART                    | Oui          |             |
| AUXILT                      | Oui          |             |
| NOMEN_LONG                  | Oui          |             |
| SIGLE                       | Oui          |             |
| NOM                         | Oui          |             |
| PRENOM                      | Oui          |             |
| CIVILITE                    | Oui          |             |
| RNA                         | Oui          |             |
| NICSIEGE                    | Oui          |             |
| RPEN                        | Oui          |             |
| DEPCOMEN                    | Oui          |             |
| ADR_MAIL                    | Oui          |             |
| NJ                          | Oui          |             |
| APEN700                     | Oui          |             |
| DAPEN                       | Oui          |             |
| APRM  (pas de conversion)   | Oui          |             |
| ESS (pas de conversion)     | Oui          |             |
| DATEESS (pas de conversion) | Oui          |             |
| TEFEN                       | Oui          |             |
| EFENCENT                    | Oui          |             |
| DEFEN                       | Oui          |             |
| CATEGORIE                   | Oui          |             |
| DCREN                       | Oui          |             |
| AMINTREN                    | Oui          |             |
| MONOACT                     | Oui          |             |
| MODEN                       | Oui          |             |
| PRODEN                      | Oui          |             |
| ESAANN                      | Oui          |             |
| TCA                         | Oui          |             |
| ESAAPEN                     | Oui          |             |
| ESASEC1N                    | Oui          |             |
| ESASEC2N                    | Oui          |             |
| ESASEC3N                    | Oui          |             |
| ESASEC4N                    | Oui          |             |
| VMAJ                        | Oui          |             |
| VMAJ1                       | Oui          |             |
| VMAJ2                       | Oui          |             |
| VMAJ3                       | Oui          |             |
| DATEMAJ                     | Oui          |             |
| longitude                   | Oui          |             |
| latitude                    | Oui          |             |
| geo_score                   | Oui          |             |
| geo_adresse                 | Oui          |             |
| geo_type                    | Oui          |             |
| geo_id                      | Oui          |             |
| geo_ligne                   | Oui          |             |
|                             |              |             |
