#!/bin/bash


#
# MANTL REST shell client v1.0
# Andrii Petruk <apetruk@cisco.com>
#


#pull in settings file
source settings


#check that username is passed as an argument
if [[ "$1" = "" ]]; then
	echo ""
	echo "Username missing!  Eg $0 bjensen Passw0rd"
	echo ""
	exit
fi

#check that password is passed as an argument
if [[ "$2" = "" ]]; then
	echo ""
	echo "Password missing!  Eg $0 admin Passw0rd"
	echo ""
	exit
fi

#check that curl is present
CURL_LOC="$(which curl)"
if [[ "$CURL_LOC" = "" ]]; then
	echo ""
	echo "Curl not found.  Please install sudo apt-get install curl etc..."
	echo ""
	exit
fi

#check that jq is present
JQ_LOC="$(which jq)"
if [[ "$JQ_LOC" = "" ]]; then
	echo ""
	echo "JQ JSON parser not found.  Please install - http://stedolan.github.io/jq/download/"
	echo ""
	exit
fi

USERNAME=$1
PASSWORD=$2
URL="$PROTOCOL://$OPENAM_SERVER:$OPENAM_SERVER_PORT/openam/json/authenticate"	

echo ""

#call URL
RESPONSE=$(curl --request POST --header "Content-Type: application/json" --header "X-OpenAM-Username: $USERNAME" --header "X-OpenAM-Password: $PASSWORD" $URL | jq .) && echo $RESPONSE | jq .

#rip out token
TOKEN=$(echo $RESPONSE | jq '.tokenId')

#store token in hidden file
if [ "$TOKEN" != null ]; then
	
	echo ""
	echo "Token stored in .token file for reuse"
	rm -f .token
	echo $TOKEN > .token
	chmod 400 .token

fi



