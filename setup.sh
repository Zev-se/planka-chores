#!/bin/bash


# Function: New setup
Echo "This script will overwrite all config files, make sure you understand what you are doing"
Echo "This scripts does not create your board nor structure, make sure this is done before running this script"
    # Run credentials
    # Run hostname
    # Run list boards and choose
    # Create test card


# Function: Ask for credentials

# Function: Ask for hostname

# Function: Test credentials

# Function: List boards to choose from
# curl -X GET -H 'Accept: application/json' -H "Authorization: Bearer TOKEN" http://HOSTNAME/api/projects/ | jq '.items | .[] | .name'
# curl -X GET -H 'Accept: application/json' -H "Authorization: Bearer TOKEN" http://HOSTNAME/api/projects/ | jq '.items | .[] | select(.name=="$CHOICE") | .id' | WRITE TO variable
# curl -X GET -H 'Accept: application/json' -H "Authorization: Bearer TOKEN" http://HOSTNAME/api/projects/PROJECT_ID | jq '.included.boards | .[] | .name' | WRITE TO FILE

# Main