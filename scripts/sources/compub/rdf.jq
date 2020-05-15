"https://sireneld.io/vocab/compub#" as $vocab |
"https://sireneld.io/attribution/" as $base |
# https://stackoverflow.com/questions/43259563/how-to-check-if-element-exists-in-array-with-jq
def IN(s): first((s == .) // empty) // false;
def makeUri(base;text):
    "<" + base + text + ">"
    ;
def makeObject(value;objectType):
    if
        (objectType == "string") then
        " \"" + .value +  "\""
    elif (objectType == "date") then
        " \"" + .value[0:10] + "T00:00:00Z\"^^<http://www.w3.org/2001/XMLSchema#dateTime>"
    elif (objectType == "siret") then
        makeUri("https://sireneld.io/siret/";value)
    elif (objectType == "decimal" or objectType == "short") then
         "\"" + value + "\"^^<http://www.w3.org/2001/XMLSchema#" + objectType + ">"
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

    .marches[10] | . as $marche | .uid as $uid | to_entries

    | map(
    if (.key[0:4] == "date" ) then
        makeTriple($uid;.key;.value;"date")

    elif ((.value | type) == "string" and .key != "codeCPV") then
        makeTriple($uid;.key;.value;"string")

    # elif (.value | type == "object" and ( ["acheteur","titulaires","autoriteConcedante","concessionnaires"] | index("titulaires")) ) then
    #     "elif works with: " + .key
         else empty end

     ) + [
         if ($marche["_type"] == "Marché") then
            ($marche.acheteur? | makeTriple($uid;"acheteur";.id;"siret")),
            ($marche.titulaires[]? | makeTriple($uid;"titulaire";.id;"siret")),
            ($marche.lieuExecution? | makeTriple($uid;"lieuExecution";.code;cog(.typeCode))),
            ($marche.dureeMois? | makeTriple($uid;"duree";(.|tostring);"short"))
            else empty
        end
      ]| .[]
