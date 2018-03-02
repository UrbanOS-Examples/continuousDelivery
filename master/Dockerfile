# Dockerfile for Jenkins Master
FROM jenkinsci/jenkins

# I would guess installing ruby, docker and inspec only needs to be done on the slaves
USER root
RUN apt-get update && apt-get install -y ruby ruby-dev gcc g++ make
RUN gem install inspec

# plugins install
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# todo figure out how to configure ec2 plugin through groovy code
# todo figure out how to configure authentication/authorization through groovy
