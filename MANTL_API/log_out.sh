#!/bin/bash


#
# MANTL REST shell client v1.0
# Andrii Petruk <apetruk@cisco.com>
#

#pull in settings file
source settings

#check that curl is present
CURL_LOC="$(which curl)"
if [[ "$CURL_LOC" = "" ]]; then
        echo ""
        echo "Curl not found.  Please install sudo apt-get install curl etc..."
        echo ""
        exit
fi

URL="$PROTOCOL://$OPENAM_SERVER:$OPENAM_SERVER_PORT/openam/json/sessions/?_action=logout&_prettyPrint=true"

if [ -e ".token" ]; then

        USER_AM_TOKEN=$(cat .token | cut -d "\"" -f 2) #remove start and end quotes

else

        echo "Token not found in .token file."
        exit
fi

#call url
echo ""
curl -k --request POST --header "iplanetDirectoryPro: $USER_AM_TOKEN" $URL

#remove token file
rm -f .token
echo ""
echo ""
echo "Local .token storage file also removed"

