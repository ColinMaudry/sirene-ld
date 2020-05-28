"https://sireneld.io/vocab/compub#" as $vocab |
"https://sireneld.io/attribution/" as $base |
{
    "accord-cadre": "AccordCadre",
    "marché public": "Marche",
    "marché subséquent": "MarcheSubsequent",
    "marché de partenariat": "MarchePartenariat",
    "concession de travaux": "ConcessionTravaux",
    "concession de service": "ConcessionService",
    "concession de service public": "ConcessionServicePublic",
    "délégation de service public": "DelegationServicePublic"
} as $natures |
# https://stackoverflow.com/questions/43259563/how-to-check-if-element-exists-in-array-with-jq
def IN(s): first((s == .) // empty) // false;
def makeUri(base;text):
    if (text == "class") then
    "<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>" else
    "<" + (base + (text|@uri)) + ">"
    end
    ;
def makeObject(value;objectType):
    if (objectType == "class") then
        makeUri($vocab;value)
    elif (objectType == "string") then
        " \"" + (value|gsub("\"";"'")|gsub("\\n";" ")) + "\""
    elif (objectType == "date") then
        " \"" + value[0:10] + "T00:00:00Z\"^^<http://www.w3.org/2001/XMLSchema#dateTime>"
    elif (objectType == "siret") then
        makeUri("https://sireneld.io/siret/";value)
    elif (objectType == "decimal" or objectType == "short") then
        "\"" + value + "\"^^<http://www.w3.org/2001/XMLSchema#" + objectType + ">"
    elif (objectType == "nature") then
        makeUri($vocab;$natures[value|ascii_downcase])
    else
        makeUri("https://sireneld.io/" + objectType + "/";value)
    end
    ;

def makeTriple(uid;key;value;objectType):
    if (objectType and value) then
    makeUri($base;uid) as $subject |
    makeUri($vocab;key) as $predicate |
    makeObject(value;objectType) as $object |

    $subject + " " + $predicate + " " + $object + " ."
    else empty end
    ;
def cog(typeCode):
    if (typeCode | not) then empty
    elif (typeCode == "Code département") then
        "departement"
    elif (typeCode == "Code région") then
        "region"
    elif (typeCode[0:3] | ascii_downcase == "code") then
        typeCode[5:] | ascii_downcase
    else empty end
    ;
def checkSiret(object):
    object |
    if (((.typeIdentifiant|not) or (.typeIdentifiant|ascii_downcase) == "siret") and (.id|length) == 14) then
      "siret"
      else empty
    end
    ;
    .marches[] | select(.id) |
     .uid as $uid |

     (if ((.modifications | length) > 0) then
        {
            "dureeMois": ([.modifications[].dureeMois?] | last),
            "montant": ([.modifications[].montant?] | last),
            "titulaires": ([.modifications[].titulaires?] | last),
            "valeurGlobale": ([.modifications[].valeurGlobale?] | last)
        } else {} end)
        as $modified |

        # Common between Marché and Contrat de concession
        (.id? | makeTriple($uid;"id";.;"string")),
        (.uid? | makeTriple($uid;"uid";.;"string")),
        (.datePublicationDonnees? | makeTriple($uid;"datePublicationDonnees";.;"date")),
        (.procedure? | makeTriple($uid;"procedure";.;"string")),
        (.source? | makeTriple($uid;"source";.;"string")),
        (.lieuExecution? | makeTriple($uid;"lieuExecution";.code;cog(.typeCode))),
        ($modified.dureeMois // .dureeMois? | makeTriple($uid;"duree";(.|tostring);"short")),
        (.objet? | makeTriple($uid;"objet";.;"string")),
        (.nature? | makeTriple($uid;"class";.;"nature")),

        # Specific to Marché
        if (._type == "Marché") then
            makeTriple($uid;"class";"MarchePublic";"class"),
            (.acheteur? | makeTriple($uid;"acheteur";.id;"siret")),
            ($modified.titulaires[]? // .titulaires[]? | makeTriple($uid;"titulaire";.id;checkSiret(.))),
            (.formePrix? | makeTriple($uid;"formePrix";.;"string")),
            (.dateNotification? | makeTriple($uid;"datePublicationDonnees";.;"date")),
            (.codeCPV? | makeTriple($uid;"codeCPV";.;"cpv")),
            ($modified.montant // .montant? | makeTriple($uid;"montant";(.|tostring);"decimal"))

        # Specific to Contrat de concession
        elif (._type == "Contrat de concession") then
            makeTriple($uid;"class";"ContratConcession";"class"),
            (.autoriteConcedante? | makeTriple($uid;"autoriteConcedante";.id;"siret")),
            (.concessionnaires[]? | makeTriple($uid;"concessionnaire";.id;checkSiret(.))),
            ($modified.valeurGlobale // .valeurGlobale? | makeTriple($uid;"valeurGlobale";(.|tostring);"decimal")),
            (.montantSubventionPublique? | makeTriple($uid;"montantSubventionPublique";(.|tostring);"decimal")),
            (.dateDebutExecution? | makeTriple($uid;"dateDebutExecution";.;"date")),
            (.dateSignature? | makeTriple($uid;"dateSignaturex";.;"date"))
            else empty
        end
