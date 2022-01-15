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
#ENV PORTAINER_HOST=$PORTAINER_HOST
RUN touch /etc/profile
RUN echo "export PORTAINER_HOST='${PORTAINER_HOST}'\n" >> /etc/profile
RUN echo "export PORTAINER_PASSWORD='${PORTAINER_PASSWORD}'\n" >> /etc/profile
RUN echo "export PORTAINER_USERNAME='${PORTAINER_USERNAME}'\n" >> /etc/profile
RUN echo "export PORTAINER_IMAGE_NAME='${PORTAINER_IMAGE_NAME}'\n" >> /etc/profile
RUN echo "export PORTAINER_SERVICE_NAME='${PORTAINER_SERVICE_NAME}'\n" >> /etc/profile

ENV SOMETHING=anything
RUN echo "${SOMETHING}" >> /root/env
RUN echo $SOMETHING >> /root/env
COPY update_portainer_service.sh /home/bin/update_portainer_service.sh

RUN chmod u+x /home/bin/update_portainer_service.sh
ADD run_cron /etc/cron.d/run_cron
#RUN printf '%s\n%s\n' "${CRON_SCHEDULE} " "$(cat /etc/cron.d/run_cron)" >/etc/cron.d/run_cron
#RUN echo "export PORTAINER_HOST=${PORTAINER_HOST}" > /etc/profile
#RUN echo $PORTAINER_HOST > /etc/profile
#RUN echo "${PORTAINER_HOST}" > /etc/profile
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
