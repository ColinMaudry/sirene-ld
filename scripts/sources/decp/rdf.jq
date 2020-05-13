"https://sireneld.io/vocab/compub#" as $vocab |
"https://sireneld.io/attribution/" as $base |

def makeUri(base;text):
    "<" + base + text + ">"
    ;
def makeTriple(uid;key;value;objectType):
    if (objectType == "string") then
    makeUri($base;uid) + " " + makeUri($vocab;key) + " \"" + .value +  "\" ."
    else empty end
    ;

    .marches[10] | .uid as $uid | to_entries

    | map(
    if (.value | type == "string") then
         makeTriple($uid;.key;.value;"string")
         else empty end
     ) | .[]
