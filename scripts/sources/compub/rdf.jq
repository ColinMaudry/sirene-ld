"https://sireneld.io/vocab/compub#" as $vocab |
"https://sireneld.io/attribution/" as $base |

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
    else
        empty
    end
    ;

def makeTriple(uid;key;value;objectType):
    makeUri($base;uid) as $subject |
    makeUri($vocab;key) as $predicate |
    makeObject(value;objectType) as $object |


    $subject + " " + $predicate + " " + $object + " ."
    ;

    .marches[100] | . as $marche | .uid as $uid | to_entries

    | map(
    if (.key[0:4] == "date" ) then
        makeTriple($uid;.key;.value;"date")

    elif (.value | type == "string") then
        makeTriple($uid;.key;.value;"string")

    # elif (.value | type == "object" and ( ["acheteur","titulaires","autoriteConcedante","concessionnaires"] | index("titulaires")) ) then
    #     "elif works with: " + .key
         else empty end

     ) + [
         if ($marche["_type"] == "Marché") then
            $marche | .acheteur? | makeTriple($uid;"acheteur";.id;"siret")
            else empty
            #$marche | .titulaires? | .[] | makeTriple($uid;"titulaires")
        end
      ]| .[]
