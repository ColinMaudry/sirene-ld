# Nomenclatures importées dans SIRENE LD

## Les nomenclatures SIRENE

Les nomenclatures propres au SIRENE et relativement courtes sont décrites dans [divers.ttl](divers.ttl).

Les nomenclatures excplicites ou ne contenant que deux valeurs n'ont pas été décrites en RDF, par exemple `PRODET` (O : Productif, N : Non productif).

## Les départements et les régions

Les département et les régions proviennent des [données RDF publiées par l'INSEE](http://rdf.insee.fr/geo/index.html).

Je doute de la fraîcheur des données RDF publiées par l'INSEE sur les communes, donc pour l'instant je prévois de les convertir moi-même.

Voir aussi [#12](https://github.com/ColinMaudry/sirene-ld/issues/12).

## Les codes APE (nomenclature NAF)

Les codes de la nomenclature NAF (Nomenclature d’activités française) servent à renseigner l'APE (Activité Principale Exercées) d'une entreprise ou d'un établissement. L'INSEE publie la nomenclature NAF dans sa révision 2008 au format RDF : http://rdf.insee.fr/codes/index.html ([fichier](http://rdf.insee.fr/codes/nafr2.ttl.zip)).

Compte tenu de la taille du fichier, je ne vais pas l'intégrer au dépôt Github.

Plus d'info sur [la nomenclature NAF](https://www.insee.fr/fr/information/3281579) (c'est très instructif).

Voir aussi [#11](https://github.com/ColinMaudry/sirene-ld/issues/11).

# Les catégories juridiques

Les catégories juridiques (`NJ` dans le fichier SIRENE) sont les nombreuses formes d'entreprises.

Plus d'info sur les catégories juridiques [sur le site de l'INSEE](https://www.insee.fr/fr/information/2028129).

Voir aussi [#20](https://github.com/ColinMaudry/sirene-ld/issues/20).

# À plus long terme

- les codes commune (COG) [#12](https://github.com/ColinMaudry/sirene-ld/issues/12)
- le registre national des associations (RNA) [#17](https://github.com/ColinMaudry/sirene-ld/issues/17)
- la nomenclature nomenclature d’activités française de l’artisanat (NAFA) [#19](https://github.com/ColinMaudry/sirene-ld/issues/19)
- les codes postaux [#13](https://github.com/ColinMaudry/sirene-ld/issues/13)
- données provenant de Wikidata [#8](https://github.com/ColinMaudry/sirene-ld/issues/8)
