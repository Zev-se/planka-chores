#!/bin/bash

# Variables
host=http://185.189.49.210:3000

# Function get token
function getToken () {
	echo "getToken"
	username=$(jq -j '.credentials.Username' variables.json)
	password=$(jq -j '.credentials.Password' variables.json)
#	echo $username
#	echo $password
	echo \"emailOrUsername=$username\&password=$password\"
	curl -X POST --data emailOrUsername=$username\&password=$password $host/api/access-tokens > token.json
	token=$(jq -j '.item' token.json)
	echo $token
}

# Function add card to board due date next week
function addCardsNextWeek (){
	echo "add Cards Next Week"
	nextWeek=$(date "+%V" )
	echo $nextWeek
}

# Fuction next sunday date
function getDateOfNextSunday () {
	dateOfNextSunday=$(date +%d-%m-%Y -d "Next Sunday")
	#echo "return date of next Sunday"
	#return $dateOfNextSunday
}

getToken
getDateOfNextSunday
addCardsNextWeek
#echo "some text" + $dateOfNextSunday
