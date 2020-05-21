"https://sireneld.io/vocab/compub#" as $vocab |
"https://sireneld.io/attribution/" as $base |
{
    "accord-cadre": "AccordCadre",
    "marché public": "Marche",
    "marché subséquent": "MarcheSubsequent",
    "marché de partenariat": "MarchePartenariat"
} as $natures |
# https://stackoverflow.com/questions/43259563/how-to-check-if-element-exists-in-array-with-jq
def IN(s): first((s == .) // empty) // false;
def makeUri(base;text):
    if (text == "class") then
    "<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>" else
    "<" + base + text + ">"
    end
    ;
def makeObject(value;objectType):
    if (objectType == "class") then
        "<" + $vocab + value + ">"
    elif    (objectType == "string") then
        " \"" + value +  "\""
    elif (objectType == "date") then
        " \"" + value[0:10] + "T00:00:00Z\"^^<http://www.w3.org/2001/XMLSchema#dateTime>"
    elif (objectType == "siret") then
        makeUri("https://sireneld.io/siret/";value)
    elif (objectType == "decimal" or objectType == "short") then
         "\"" + value + "\"^^<http://www.w3.org/2001/XMLSchema#" + objectType + ">"
    elif (objectType == "nature") then
         "<" + $vocab + $natures[value|ascii_downcase] + ">"
    else
        makeUri("https://sireneld.io/" + objectType + "/";value)
    end
    ;

def makeTriple(uid;key;value;objectType):
    if (objectType) then
    makeUri($base;uid) as $subject |
    makeUri($vocab;key) as $predicate |
    makeObject(value;objectType) as $object |

    $subject + " " + $predicate + " " + $object + " ."
    else empty end
    ;
def cog(typeCode):
    if (typeCode == "Code département") then
        "departement"
    elif (typeCode == "Code région") then
        "region"
    elif (typeCode[0:3] | ascii_downcase == "code") then
        typeCode[5:] | ascii_downcase
    else empty
    end
    ;

    .marches[] | . as $marche
    | .uid as $uid
    | (if ((.modifications | length) > 0) then
        {
            "dureeMois": ([.modifications[].dureeMois?] | last),
            "montant": ([.modifications[].montant?] | last),
            "titulaires": ([.modifications[].titulaires?] | last),
            "concessionnaires": ([.modifications[].concessionnaires?] | last)
        } else empty end)
        as $modified
    | [
        # Commons between Marché and Contrat de concession
        (.id? | makeTriple($uid;"id";.;"string")),
        (.uid? | makeTriple($uid;"uid";.;"string")),
        (.datePublicationDonnees? | makeTriple($uid;"datePublicationDonnees";.;"date")),
        (.procedure? | makeTriple($uid;"procedure";.;"string")),
        (.source? | makeTriple($uid;"source";.;"string")),
        (.lieuExecution? | makeTriple($uid;"lieuExecution";.code;cog(.typeCode))),
        ($modified.dureeMois // .dureeMois? | makeTriple($uid;"duree";(.|tostring);"short")),
        ($modified.montant // .montant? | makeTriple($uid;"montant";(.|tostring);"decimal")),
        (.objet? | makeTriple($uid;"objet";.;"string")),
        (.nature? | makeTriple($uid;"class";.;"nature")),

        # Specific to Marché
        if ($marche["_type"] == "Marché") then
            makeTriple($uid;"class";"MarchePublic";"class"),
            (.acheteur? | makeTriple($uid;"acheteur";.id;"siret")),
            ($modified.titulaires // .titulaires[]? | makeTriple($uid;"titulaire";.id;"siret")),
            (.formePrix? | makeTriple($uid;"formePrix";.;"string")),
            (.dateNotification? | makeTriple($uid;"datePublicationDonnees";.;"date")),
            (.codeCPV? | makeTriple($uid;"codeCPV";.;"cpv"))




            else empty
        end
      ]| .[]
