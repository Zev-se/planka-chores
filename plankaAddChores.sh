#!/bin/bash

# Function get token
function getToken () {
	echo "getToken"
}

# Function add card to board due date next week
function addCardsNextWeek (){
	echo "add Cards Next Week"
}

# Fuction next sunday date
function getDateOfNextSunday () {
	dateOfNextSunday=$(date +%d-%m-%Y -d "Next Sunday")
	echo "return date of next Sunday"
	#return $dateOfNextSunday
}

getToken
getDateOfNextSunday
echo "some text" + $dateOfNextSunday
