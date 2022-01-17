#!/bin/bash

source /etc/profile

USERNAME=$PORTAINER_USERNAME
PASSWORD=$PORTAINER_PASSWORD
HOST=$PORTAINER_HOST
SERVICE_NAME=$PORTAINER_SERVICE_NAME
IMAGE_NAME=$PORTAINER_IMAGE_NAME
SCHEDULE=$CRON_SCHEDULE

LOGIN_TOKEN=$(curl -k -s -H "Content-Type: application/json" -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" -X POST $HOST/api/auth | jq -r .jwt)
ENDPOINT_ID=$(curl -k -s -H "Authorization: Bearer $LOGIN_TOKEN" $HOST/api/endpoints | jq ."[].Id")
SERVICE=$(curl -k -s -H "Authorization: Bearer $LOGIN_TOKEN" $HOST/api/endpoints/${ENDPOINT_ID}/docker/services | jq -c ".[] | select( .Spec.Name==(\"$SERVICE_NAME\"))")

ID=$(echo $SERVICE | jq  -r .ID)
SPEC=$(echo $SERVICE | jq .Spec)
VERSION=$(echo $SERVICE | jq .Version.Index)
FORCE_UPDATE=$(echo $SPEC | jq  ".TaskTemplate.ForceUpdate" | bc)
let "FORCE_UPDATE=${FORCE_UPDATE}+1"
UPDATE=$(echo $SPEC | jq ".TaskTemplate.ContainerSpec.Image |= \"$IMAGE_NAME\" " | jq ".TaskTemplate.ForceUpdate = ${FORCE_UPDATE} ")

curl -k -s -H "Content-Type: application/json" \
-H "Authorization: Bearer $LOGIN_TOKEN" -X POST -d "${UPDATE}" \
"$HOST/api/endpoints/${ENDPOINT_ID}/docker/services/$ID/update?version=$VERSION"
