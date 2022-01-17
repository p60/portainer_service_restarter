FROM ubuntu:latest
MAINTAINER jayre@reactiondata.com

# Add crontab file in the cron directory
RUN mkdir -p /home/bin
ARG PORTAINER_HOST
ARG PORTAINER_PASSWORD
ARG PORTAINER_USERNAME
ARG PORTAINER_IMAGE_NAME
ARG PORTAINER_SERVICE_NAME
ARG CRON_SCHEDULE

RUN touch /etc/profile
RUN echo "export PORTAINER_HOST='${PORTAINER_HOST}'\n" >> /etc/profile
RUN echo "export PORTAINER_PASSWORD='${PORTAINER_PASSWORD}'\n" >> /etc/profile
RUN echo "export PORTAINER_USERNAME='${PORTAINER_USERNAME}'\n" >> /etc/profile
RUN echo "export PORTAINER_IMAGE_NAME='${PORTAINER_IMAGE_NAME}'\n" >> /etc/profile
RUN echo "export PORTAINER_SERVICE_NAME='${PORTAINER_SERVICE_NAME}'\n" >> /etc/profile

RUN touch /etc/cron.d/run_cron
RUN echo "${CRON_SCHEDULE} root /home/bin/update_portainer_service.sh >> /var/log/cron.log  2>&1 \n" >> /etc/cron.d/run_cron
RUN cat /etc/cron.d/run_cron

COPY update_portainer_service.sh /home/bin/update_portainer_service.sh
RUN chmod u+x /home/bin/update_portainer_service.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/run_cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

#Install Cron
RUN apt-get update
RUN apt-get -y install cron
RUN apt-get -y install jq
RUN apt-get -y install curl
RUN apt-get -y install bc

# Run the command on container startup

CMD cron && tail -f /var/log/cron.log
