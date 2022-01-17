# Portainer Service Restarter
This allows you to periodically restart a Portainer service via a cron job, and the Portainer API. It uses docker build arguments to specify the credentials for Portainer.

### Building
docker build . --build-arg PORTAINER_HOST="https://myportainerhost:9000" --build-arg PORTAINER_IMAGE_NAME="dockerorg/image:latest" --build-arg PORTAINER_SERVICE_NAME="subscriber" --build-arg PORTAINER_USERNAME="user" --build-arg PORTAINER_PASSWORD="password" -t PrivateDockerHubUser/myimage:latest
