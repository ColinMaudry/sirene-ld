## Échantillons

Ces échantillons ont été produits à partir de geo-sirene_35_small.csv, un extrait du fichier des entreprises enregistrées en Ille-et-Vilaine (Bretagne, 35), téléchargé sur http://data.cquest.org/geo_sirene/last/ (les 99 premiers enregistrements au 27 avril 2018).

Le fichier .ttl est un fichier [Turtle](https://fr.wikipedia.org/wiki/Turtle_(syntaxe)) et le produit de l'exécution de [Tarql](https://github.com/tarql/tarql) avec une requête SPARQL en paramètre :

```shell
tarql -e UTF-8 sparql/csv2rdf.rq échantillons/geo-sirene_35_small.csv  > échantillons/geo-sirene_35_small.ttl
```

## Suivi du traitement des champs

Les champs de la base SIRENE sont documentés dans [dessin_L2_description_complete.pdf](https://github.com/ColinMaudry/sirene-ld/blob/master/dessin_L2_description_complete.pdf).

| Champ        | Conversion ? | Commentaire                                                   |
| ------------ | ------------ | ------------------------------------------------------------- |
| SIREN        | Oui          | Dans l'URI de l'entreprise et de l'établissement.             |
| NIC          | Oui          | Dans l'URI de l'établissement.                                |
| L1_NORMALISE | Oui          |                                                               |
| L2_NORMALISE | Oui          |                                                               |
| L3_NORMALISE | Oui          |                                                               |
| L4_NORMALISE | Oui          |                                                               |
| L5_NORMALISE | Oui          |                                                               |
| L6_NORMALISE | Oui          |                                                               |
| L7_NORMALISE | Oui          |                                                               |
| L1_DECLAREE  | Oui          |                                                               |
| L2_DECLAREE  | Oui          |                                                               |
| L3_DECLAREE  | Oui          |                                                               |
| L4_DECLAREE  | Oui          |                                                               |
| L5_DECLAREE  | Oui          |                                                               |
| L6_DECLAREE  | Oui          |                                                               |
| L7_DECLAREE  | Oui          |                                                               |
| NUMVOIE      | Oui          |                                                               |
| INDREP       | Oui          |                                                               |
| TYPVOIE      | Oui          |                                                               |
| LIBVOIE      | Oui          |                                                               |
| CODEPOS      | Oui          |                                                               |
| CEDEX        | Oui          |                                                               |
| RPET         | **Non**      | Absent des fichiers source géo-taggés.                        |
| LIBREG       | **Non**      | Absent des fichiers source géo-taggés.                        |
| DEPET        | Oui          | Utilisé dans le code commune (`sirext:commune`).              |
| ARRONET      | **Non**      | Absent des fichiers source géo-taggés.                        |
| CTONET       | **Non**      | Absent des fichiers source géo-taggés.                        |
| COMET        | Oui          | Utilisé dans le code commune (`sirext:commune`).              |
| LIBCOM       | **Non**      | Absent des fichiers source géo-taggés mais voir #12.          |
| DU           | **Non**      | Absent des fichiers source géo-taggés.                        |
| TU           | **Non**      | Absent des fichiers source géo-taggés.                        |
| UU           | **Non**      | Absent des fichiers source géo-taggés.                        |
| EPCI         | **Non**      | Absent des fichiers source géo-taggés.                        |
| TCD          | Oui          | Ajout d'un objet `sirext:TDC` et du libellé.                  |
| ZEMET        | **Non**      | Absent des fichiers source géo-taggés.                        |
| SIEGE        | Oui          | Détermine si la classe `sirext:Siege` est attribuée.          |
| ENSEIGNE     | Oui          |                                                               |
| IND_PUBLIPO  | Oui          |                                                               |
| DIFFCOM      | Oui          |                                                               |
| AMINTRET     | Oui          |                                                               |
| NATETAB      | Oui          |                                                               |
| LIBNATETAB   | **Non**      | Absent, mais ajout d'un objet `sirext:NATETAB` et du libellé. |
| APET700      | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| LIBAPET      | **Non**      | Absent, mais ajout d'un objet `skos:Concept` et du libellé.   |
| DAPET        | Oui          |                                                               |
| TEFET        | Oui          | Ajout d'un objet `sirext:TEF` et du libellé.                  |
| LIBTEFET     | **Non**      | Absent, mais ajout d'un objet `sirext:TEF` et du libellé.     |
| EFETCENT     | Oui          |                                                               |
| DEFET        | Oui          |                                                               |
| ORIGINE      | Oui          |                                                               |
| DCRET        | Oui          |                                                               |
| DDEBACT      | Oui          |                                                               |
| ACTIVNAT     | Oui          | Ajout d'un objet `sirext:ACTIVNAT` et du libellé.             |
| LIEUACT      | Oui          | Ajout d'un objet `sirext:LIEUACT` et du libellé.              |
| ACTISURF     | Oui          | Ajout d'un objet `sirext:ACTISURF` et du libellé.             |
| SAISONAT     | Oui          | Ajout d'un objet `sirext:SAISONAT` et du libellé.             |
| MODET        | Oui          | Ajout d'un objet `sirext:MOD` et du libellé.                  |
| PRODET       | Oui          |                                                               |
| PRODPART     | Oui          | Ajout d'un objet `sirext:PRODPART` et du libellé.             |
| AUXILT       | Oui          |                                                               |
| NOMEN_LONG   | Oui          |                                                               |
| SIGLE        | Oui          |                                                               |
| NOM          | Oui          |                                                               |
| PRENOM       | Oui          |                                                               |
| CIVILITE     | Oui          |                                                               |
| RNA          | Oui          |                                                               |
| NICSIEGE     | Oui          |                                                               |
| RPEN         | Oui          |                                                               |
| DEPCOMEN     | Oui          |                                                               |
| ADR_MAIL     | Oui          |                                                               |
| NJ           | Oui          | Attribution d'une sous-classe de `sirecj:CJ`.                 |
| LIBNJ        | **Non**      | Mais attribution de `sirecj:CJ` avec libellé.                 |
| APEN700      | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| LIBAPEN      | **Non**      | Absent, mais ajout d'un objet `skos:Concept` et du libellé.   |
| DAPEN        | Oui          |                                                               |
| APRM         | Oui          | Voir aussi #19 sur l'intégration des codes NAFA.              |
| ESS          | Oui          |                                                               |
| DATEESS      | Oui          |                                                               |
| TEFEN        | Oui          | Ajout d'un objet `sirext:TEF` et du libellé.                  |
| LIBTEFEN     | **Non**      | Absent, mais ajout d'un objet `sirext:TEF` et du libellé.     |
| EFENCENT     | Oui          |                                                               |
| DEFEN        | Oui          |                                                               |
| CATEGORIE    | Oui          | Attribution d'une sous-classe de `sirext:Entreprise`.         |
| DCREN        | Oui          |                                                               |
| AMINTREN     | Oui          |                                                               |
| MONOACT      | Oui          | Ajout d'un objet `sirext:MONOACT` et du libellé.              |
| MODEN        | Oui          | Ajout d'un objet `sirext:MOD` et du libellé.                  |
| PRODEN       | Oui          |                                                               |
| ESAANN       | Oui          |                                                               |
| TCA          | Oui          | Ajout d'un objet `sirext:TCA` et du libellé.                  |
| ESAAPEN      | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| ESASEC1N     | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| ESASEC2N     | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| ESASEC3N     | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| ESASEC4N     | Oui          | Ajout d'un objet `skos:Concept` et du libellé.                |
| VMAJ         | **Non**      | Lorsque j'intégrerai les mises à jour.                        |
| VMAJ1        | **Non**      | Lorsque j'intégrerai les mises à jour.                        |
| VMAJ2        | **Non**      | Lorsque j'intégrerai les mises à jour.                        |
| VMAJ3        | **Non**      | Lorsque j'intégrerai les mises à jour.                        |
| DATEMAJ      | Oui          |                                                               |
| longitude    | Oui          |                                                               |
| latitude     | Oui          |                                                               |
| geo_score    | Oui          |                                                               |
| geo_adresse  | Oui          |                                                               |
| geo_type     | Oui          |                                                               |
| geo_id       | Oui          |                                                               |
| geo_ligne    | Oui          |                                                               |
