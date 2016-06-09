#!/bin/bash


#
# MANTL REST shell client v1.0
# Andrii Petruk <apetruk@cisco.com>
#


#pull in settings file
source settings

#check that URL is passed as an argument
if [ "$1" = "" ]; then
	echo "Argument missing.  Requires APP - JSON FILE NAME "
	exit
fi

#check that curl is present
CURL_LOC="$(which curl)"
if [ "$CURL_LOC" = "" ]; then
	echo "Curl not found.  Please install sudo apt-get install curl etc..."
	exit
fi

APP=$1
MANTL_MARATON="$MANTL_PREFIX://$MANTL_SERVER:$MANTL_SERVER_PORT/marathon/v2/apps"



if [ -e ".token" ]; then
        USER_AM_TOKEN=$(cat .token | cut -d "\"" -f 2) #remove start and end quotes
        echo "The following token value was found:"
        echo ""
        echo "$USER_AM_TOKEN"
        echo ""
else
        echo "Token not found in .token file.  Use  ./get_tokenid.sh to create"
fi
        echo ""


curl -k -X POST  --cookie "amlbcookie=01; iPlanetDirectoryPro=$USER_AM_TOKEN"  -H "Content-type: application/json" $MANTL_MARATON -d@$APP

