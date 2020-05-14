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
    else empty end
    ;

def makeTriple(uid;key;value;objectType):
    makeUri($base;uid) as $subject |
    makeObject(value;objectType) as $object |
    makeUri($vocab;key) as $predicate |


    $subject + " " + $predicate + " " + $object + " ."
    ;

    .marches[] | .uid as $uid | to_entries

    | map(
    if (.key[0:4] == "date" ) then
        makeTriple($uid;.key;.value;"date")

    elif (.value | type == "string") then
         makeTriple($uid;.key;.value;"string")
         else empty end
     ) | .[]
