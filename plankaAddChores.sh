#!/bin/bash

# Variables
host=http://185.189.49.210:3000 #Add to variables.json

# Function get token
function getToken () {
	echo "getToken"
	username=$(jq -j '.credentials.Username' variables.json)
	password=$(jq -j '.credentials.Password' variables.json)
#	echo $username
#	echo $password
	echo \"emailOrUsername=$username\&password=$password\"
	curl -X POST --data emailOrUsername=$username\&password=$password $host/api/access-tokens > token.json #add to variables.json
	token=$(jq -j '.item' token.json)
	echo $token
}

# Function add card to board due date next week
function addCardsNextWeek (){
	echo "add Cards Next Week"
	dateOfNextSunday=$(date +%d-%m-%Y -d "Next Sunday")
	declare -i nextWeek=$(date "+%V"+1 )
#	echo $nextWeek
			# Just a memo on how to output the correct data jq -j '.weeks."42"[]' data.json
	# Memo continue 
	for i in $(jq -r '.weeks."$nextWeek"[].id' data.json); #will $nextWeek work here? Test
		do 

				# Add card via api
				# Should this accept multiple variables?	
		done

}

# main
getToken
addCardsNextWeek
#echo "some text" + $dateOfNextSunday
