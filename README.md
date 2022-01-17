# Portainer Service Restarter
This allows you to periodically restart a Portainer/Docker Swarm service via a cron job, and the Portainer API. It uses docker build arguments to specify the credentials for Portainer. Note it was built against an older version (1.16.5) of Portainer, not sure if there are breaking API changes in newer versions or not.

### Building Example
```docker build . --build-arg PORTAINER_HOST="https://myportainerhost:9000" --build-arg PORTAINER_IMAGE_NAME="dockerorg/image:latest" --build-arg PORTAINER_SERVICE_NAME="subscriber" --build-arg PORTAINER_USERNAME="user" --build-arg PORTAINER_PASSWORD="password" --build-arg CRON_SCHEDULE="*/5 * * * *" -t PrivateDockerHubUser/myimage:latest```
