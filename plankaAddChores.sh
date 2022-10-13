#!/bin/bash

# Variables
host=$(jq -j '.basics.host' variables.json)
board=$(jq -j '.basics.mainBoard' variables.json)
list=$(jq -j '.basics.list' variables.json)
position=$(jq -j '.basics.position' variables.json)

# Function get token
function getToken () {
	username=$(jq -j '.credentials.username' variables.json)
	password=$(jq -j '.credentials.password' variables.json)
	curl -X POST --data emailOrUsername=$username\&password=$password $host/api/access-tokens > token.json #add to variables.json
	token=$(jq -j '.credentials.token' variables.json)
}

# Function add card to board due date next week
function addCardsNextWeek (){
	dateOfNextSunday=$(date +%d-%m-%Y -d "Next Sunday")
	declare -i nextWeek=$(date "+%V"+1 )

	for i in $(jq -r '.weeks."'$nextWeek'"[].id' data.json); #will $nextWeek work here? Test
		do 
			chore=$(jq -r '.weeks."'$nextWeek'"[] | select(.id == "'$i'").chore' data.json)
			curl -X POST -H 'Accept: application/json' -H "Authorization: Bearer $token" --data "name=$chore&listId=$list&position=$position" $host/api/boards/$board/cards | jq
				# Should this accept multiple variables?
				# Add chore label?

		done;

}

# main
getToken
addCardsNextWeek
