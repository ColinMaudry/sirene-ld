## Échantillons

Ces échantillons ont été produits à partir de geo-sirene_35_small.csv, un extrait du fichier des entreprises enregistrées en Ille-et-Vilaine (Bretagne, 35), téléchargé sur http://data.cquest.org/geo_sirene/last/ (les 99 premiers enregistrements au 27 avril 2018).

Le fichier .ttl est un fichier [Turtle](https://fr.wikipedia.org/wiki/Turtle_(syntaxe)) et le produit de l'exécution de [Tarql](https://github.com/tarql/tarql) avec une requête SPARQL en paramètre :

```shell
tarql -v sparql/csv2rdf.rq échantillons/geo-sirene_35_small.csv  > échantillons/sirene_35.ttl
```
