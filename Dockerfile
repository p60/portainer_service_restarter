FROM ubuntu:latest
MAINTAINER jayre@reactiondata.com

# Add crontab file in the cron directory
RUN mkdir -p /home/bin
COPY update_portainer_service.sh /home/bin/update_portainer_service.sh
RUN chmod 0644 /home/bin/update_portainer_service.sh
ADD run_cron /etc/cron.d/run_cron


# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/run_cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

#Install Cron
RUN apt-get update
RUN apt-get -y install cron

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
