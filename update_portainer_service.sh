#!/bin/bash

source /etc/profile

cat /etc/cron.d/run_cron

echo "TRYING TO RUN SCRIPT"

USERNAME=$PORTAINER_USERNAME
PASSWORD=$PORTAINER_PASSWORD
HOST=$PORTAINER_HOST
SERVICE_NAME=$PORTAINER_SERVICE_NAME
IMAGE_NAME=$PORTAINER_IMAGE_NAME
echo $HOST

LOGIN_TOKEN=$(curl -k -s -H "Content-Type: application/json" -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" -X POST $HOST/api/auth | jq -r .jwt)
echo $LOGIN_TOKEN
echo $HOST
ENDPOINT_ID=$(curl -k -s -H "Authorization: Bearer $LOGIN_TOKEN" $HOST/api/endpoints | jq ."[].Id")
echo $ENDPOINT_ID
echo $SERVICE_NAME
curl -k -s -H "Authorization: Bearer $LOGIN_TOKEN" "$HOST/api/endpoints/${ENDPOINT_ID}/docker/services"
SERVICE=$(curl -k -s -H "Authorization: Bearer $LOGIN_TOKEN" $HOST/api/endpoints/${ENDPOINT_ID}/docker/services | jq -c ".[] | select( .Spec.Name==(\"$SERVICE_NAME\"))")

echo "SERVICE IS"
echo $SERVICE

ID=$(echo $SERVICE | jq  -r .ID)
echo "ID IS"
echo $ID
SPEC=$(echo $SERVICE | jq .Spec)
echo "SPEC IS"
echo $SPEC
VERSION=$(echo $SERVICE | jq .Version.Index)
echo $VERSION
FORCE_UPDATE=$(echo $SPEC | jq  ".TaskTemplate.ForceUpdate" | bc)
echo "FORCE UPDATE WAS"
echo $FORCE_UPDATE
let "FORCE_UPDATE=${FORCE_UPDATE}+1"
echo "FORCE UPDATE IS"
echo $FORCE_UPDATE
UPDATE=$(echo $SPEC | jq ".TaskTemplate.ContainerSpec.Image |= \"$IMAGE_NAME\" " | jq ".TaskTemplate.ForceUpdate = ${FORCE_UPDATE} ")

curl -k -H "Content-Type: application/json" \
-H "Authorization: Bearer $LOGIN_TOKEN" -X POST -d "${UPDATE}" \
"$HOST/api/endpoints/${ENDPOINT_ID}/docker/services/$ID/update?version=$VERSION"
