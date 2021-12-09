#!/usr/bin/env bash

jq_string(){ :
    jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]'
}

f1(){ :
    while IFS="=" read -r key value; do
#        echo "$1$key = $value"
        json_pars[$1$key]="$value"
        if jq '.[]' &> /dev/null <<< "$value" ; then
            < <( <<<"$value" jq_string ) f1 "$1$key."
        fi
    done 
}

declare -A json_pars
< <( < test_json sed 's/\\n/\\\\n/g' | jq_string ) f1 "."


#echo -e "${json_pars[.message.text]}"
Fprint(){ :
    for key in "${!json_pars[@]}"; do
        echo "$key = ${json_pars[$key]}"
    done

}
#Fprint
#echo ${!json_pars[@]}
