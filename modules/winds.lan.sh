#!/bin/bash

WINDS_DOMAIN="$(basename -- "$0" .sh)"

# Prepare the app data folders
echo ">> Creating /srv/http/$WINDS_DOMAIN folder..."
mkdir -p /srv/http/$WINDS_DOMAIN &>/dev/null
echo ">> Creating /srv/dbs/$WINDS_DOMAIN folder..."
mkdir -p /srv/dbs/$WINDS_DOMAIN &>/dev/null

# Install UI for Docker
echo ">> Running GetStream Winds..."
docker run \
    --restart=always \
    --name="$WINDS_DOMAIN" \
    -d \
    -e "VIRTUAL_HOST=$WINDS_DOMAIN" \
    -e "STREAM_APP_ID=''" \
    -e "STREAM_API_KEY=''" \
    -e "STREAM_API_SECRET=''" \
    -e "STREAM_ANALYTICS_TOKEN=''" \
    -e "MONGO_URI=mongodb://localhost" \
    -e "API_BASE_URL=$WINDS_DOMAIN" \
    -v "/srv/http/$WINDS_DOMAIN:/home/app" \
    -v "/srv/dbs/$WINDS_DOMAIN:/var/lib/mongodb" \
    getstream/winds &>/dev/null

# Wait until the docker is up and running
echo -n ">> Waiting for GetStream Winds to start..."
while [ ! $(docker top $WINDS_DOMAIN &>/dev/null && echo $?) ]
do
    echo -n "."
    sleep 0.5
done
echo "started!"

# Print friendly done message
echo "-----------------------------------------------------"
echo "All right! Everything seems to be installed correctly. Have a nice day!"
echo ">> URL: http://${WINDS_DOMAIN}/"
echo ">> Installation instructions: https://github.com/GetStream/Winds#installation"
echo "-----------------------------------------------------"