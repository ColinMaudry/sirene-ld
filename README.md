# SIRENE LD

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

| Fait  | Description                                                                                                                                                                                                                                                                                                                                                             | Progression                                                                                                                        |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| **✓** | Transformer les données CSV au format [RDF](https://fr.wikipedia.org/wiki/Resource_Description_Framework), dans la sérialisation Turtle, en utilisant [Tarql](https://github.com/tarql/tarql) et une [requête SPARQL](https://fr.wikipedia.org/wiki/SPARQL) de type `CONSTRUCT` ([csv2rdf.rq](https://github.com/ColinMaudry/sirene-ld/blob/master/sparql/csv2rdf.rq)).<br/>[Résultat](https://github.com/ColinMaudry/sirene-ld/tree/master/échantillons)        | [transform](https://github.com/ColinMaudry/sirene-ld/labels/transform)                                                             |
|       | Charger les données dans un [triple store](https://fr.wikipedia.org/wiki/Triplestore), une base données dédiée au stockage et au requêtages de triplets RDF ([GraphDB Free](https://ontotext.com/products/graphdb/editions/) ou [Stardog Community](https://www.stardog.com/)).                                                                                         | [triplestore](https://github.com/ColinMaudry/sirene-ld/labels/triplestore)                                                         |
| **✓**      | Créer et publier une ou plusieurs ontologie pour définir les classes et propriétés des entreprises et établissements décrits dans les données du SIRENE.<br/>[Résultat](https://github.com/ColinMaudry/sirene-ld/tree/master/ontologies)                                                                                                                                                                                                           | [ontology](https://github.com/ColinMaudry/sirene-ld/labels/ontology)                                                                                                                                   |
|       | Publier les données, probablement en utilisant [Elda](http://epimorphics.github.io/elda/current/index.html) (voir [SIRENE LD Web](https://github.com/ColinMaudry/sirene-ld-web))   <ul><li>API REST riche et multiformats (JSON-LD, RDF/XML, Turtle, CSV)</li><li>Interface Web</li></ul>                                                                               | [api](https://github.com/ColinMaudry/sirene-ld/labels/api) \| [frontend](https://github.com/ColinMaudry/sirene-ld/labels/frontend) |
|       | Intégrer automatiquement les mises à jour quotidiennes publiées par l'INSEE et [géocodées par @cquest](http://data.cquest.org/geo_sirene/quotidien/).                                                                                                                                                                                                                   | [data-update](https://github.com/ColinMaudry/sirene-ld/labels/data-update)                                                         |
|       | Enrichir les données à partir de [Wikidata](https://fr.wikipedia.org/wiki/Wikidata) et d'autres sources externes.                                                                                                                                                                                                                                                         | [enrich](https://github.com/ColinMaudry/sirene-ld/labels/enrich)                                                                   |
|       | Publier les données sous forme de [Linked Data Fragments](http://linkeddatafragments.org/) pour streamer les résultats de requêtes SPARQL.                                                                                                                                                                                                                                         | [ldf](https://github.com/ColinMaudry/sirene-ld/labels/ldf)                                                                         |
|       | Intégrer le tout au [Service public de la donnée](https://www.data.gouv.fr/fr/reference) (chiche !?)                                                                                                                                                                                                                                                                    |                                                                                                                                    |

- Vous trouverez des échantillons de données (CSV source et résultats de transformation) dans `[échantillons](https://github.com/ColinMaudry/sirene-ld/tree/master/échantillons)`

## Stats en vrac

*Au 3 mai 2018*

### Taille

| Quoi ?                                                    | Taille                     | Zippé  |
| --------------------------------------------------------- | -------------------------- | ------ |
| Le SIRENE géo-codé (CSV)                                  | 7,7 Go / 10 970 267 lignes | 1,5 Go |
| Le SIRENE géo-codé de l'Ille-et-Vilaine (35) (CSV)        | 106 Mo / 152 835 lignes    |        |
| Le SIRENE géo-codé de l'Ille-et-Vilaine (35) (Turtle RDF) | 560 Mo                     |        |
|                                                           |                            |        |


### Temps

Le temps est mesuré avec [time](https://fr.wikipedia.org/wiki/Time_(Unix)).

| Quoi ?                                                       | Temps          |
| ------------------------------------------------------------ | -------------- |
| Conversion du SIRENE géo-codé de l'Ille-et-Vilaine en Turtle | 1 min. 30 sec. |
|                                                              |                |

## Soutien

Je compte consacrer pas mal de temps à ce projet et je devrai louer un serveur dédié afin de traiter, héberger et publier la masse de données que représente le SIRENE une fois transformé en graphe (en moyenne 500 Mo par département), sans compter les données périphériques (codes officiels géographiques, nomenclature NAF, etc.).

Ainsi, pour soutenir ce projet vous pouvez :

- ajouter une étoile dans Github (en haut à droite de l'écran)
- retweeter les tweets qui ont [le hashtag #sireneLD](https://twitter.com/hashtag/sireneLD?f=tweets)
- m'envoyer vos commentaires et encouragements par email ([colin@maudry.com](mailto:colin@maudry.com))
- me faire un don (j'étudie la possibilité de passer par [Liberapay](https://liberapay.com/))

[![paypal](https://www.paypalobjects.com/fr_FR/FR/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=R6D94GJG3YJ2Q)
