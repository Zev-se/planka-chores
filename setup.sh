#!/bin/bash

# Function: Ask for credentials
function basicVariables(){
    echo "Please enter your username: "
    #read username
    echo "Please enter your password: "
    #read password
    echo "Please enter hostname of the server (including https://): "
    #read host
    token=$(curl -s -X POST --data emailOrUsername=$username\&password=$password $host/api/access-tokens | jq -j '.item')
    if [[ $token=="{\"item\":\"ey*" ]]; 
    then
        echo "working credentials"
    else 
        echo "Credentials does not seem to work. Exiting."
        break
    fi
}

# Function: List projects, boards and lists and choose
function chooseProjectAndBoard(){
    projects=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/projects/ | jq -j '[ .items | .[] | .name ] | @csv' | tr -d '"' | tr -d ' ')
    declare -i i=0
    echo "Please enter what project you would like to use"
    for p in ${projects//,/ } #If name contains space that will have been removed to create a good list as bash use space as separator
        do
            echo "$i.$p"
            i=i+1
        done
    read projectChoice
    projectID=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/projects/ | jq -r '.items  | .['$projectChoice'] | .id')
    echo $projectID

    boards=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/projects/$projectID | jq -r '[ .included.boards | .[] | .name  ] | @csv' | tr -d '"' | tr -d ' ')
    declare -i i=0
    echo "Please enter what board you would like to use"
    for b in ${boards//,/ }
        do
            echo "$i.$b"
            i=i+1
        done
    read boardChoice
    boardID=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/projects/$projectID | jq -r '.included.boards | .['$boardChoice'] | .id')
    echo "boardID: $boardID"

    lists=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/boards/$boardID | jq -r '[ .included.lists | .[] | .name ] | @csv' | tr -d '"' | tr -d ' ')
    declare -i i=0
    echo "Please enter what list you would like to use"
    for l in ${lists//,/ }
        do
            echo "$i.$l"
            i=i+1
        done
    read listChoice
    listId=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/boards/$boardID | jq -r '.included.lists | .['$listChoice'] | .id')
    echo "ListID: $listId"
}

function testCreateCard(){
    echo "Testing to create card 'setup-test'"
    curl -s -X POST -H 'Accept: application/json' -H "Authorization: Bearer $token" --data "name=setup-test&listId=$listId&position=1" $host/api/boards/$boardID/cards | jq 
    cardTest=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/boards/$boardID | jq '.included.cards | .[] | select(.name=="setup-test")')
    echo $cardTest
    if [[ cardTest="{\n   id:*" ]];
        then
            echo "Yey, test-card worked, will now delete it and continue"
            cardID=$(curl -s -X GET -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/boards/$boardID | jq -j '.included.cards | .[] | select(.name=="setup-test") | .id')
            curl -s -X DELETE -H 'Accept: application/json' -H "Authorization: Bearer $token" $host/api/cards/$cardID
        else
            echo "Ahh, crap, something seems wrong. Can't create card, please troubleshoot. Here's some debug information for you"
            #run debug function
            break
        fi
}

function createFilesFromTemplate(){
    echo "Creating files you will need"
}

function checkRequirements(){
    #jq, curl, 
    if ! type "$jq" > /dev/null; then # this test does not work, change it
    echo "jq is not installed, please install it"
    echo "Ubuntu/Debian: sudo apt install jq"
    echo "Fedora: sudo dnf install jq"
    echo "Arch: sudo pacman -S jq"
    break
fi
    if ! type "$jq" > /dev/null; then # this test does not work, change it
    echo "curl is not installed, please install it"
    echo "Ubuntu/Debian: sudo apt install curl"
    echo "Fedora: sudo dnf install curl"
    echo "Arch: sudo pacman -S curl"
    break
fi
}
# Main
echo "This script will overwrite all config files, make sure you understand what you are doing"
echo "This scripts does not create your board nor structure, make sure this is done before running this script"
#checkRequirements
basicVariables
chooseProjectAndBoard
testCreateCard
#createFilesFromTemplate