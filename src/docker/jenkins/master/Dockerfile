FROM jenkins/jenkins:lts

ARG docker_config
ENV DOCKER_CONFIG=${docker_config}
COPY config.json ${docker_config}/config.json

ENV JENKINS_REF /usr/share/jenkins/ref

# install jenkins plugins
COPY plugins.txt $JENKINS_REF/
RUN jenkins-plugin-cli -f $JENKINS_REF/plugins.txt

# ECS currently has a hard limit of 3g for jenkins master.
# 3072m - 256m = 2816m
# Cloudbees recommends setting a minimum of at least half the max.
# https://support.cloudbees.com/hc/en-us/articles/204859670-Java-Heap-settings-best-practice
# 3072m/2 = 1536m
ENV JAVA_OPTS -Dorg.eclipse.jetty.server.Request.maxFormContentSize=100000000 \
			  -Dhudson.diyChunking=false \
			  -Djenkins.install.runSetupWizard=false \
			  -Xmx2816m \
			  -Xms1536m

# copy scripts
COPY init.groovy.d $JENKINS_REF/init.groovy.d/

USER root
ENV DEBIAN_FRONTEND noninteractive

# Install updated apt repositories and necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # install dependencies for adding package repository
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
    # add docker-ce repository
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -  \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Install the actual apt packages we need
RUN apt-get update && apt-get install -y --no-install-recommends \
        docker-ce \
        ruby-full \
        build-essential \
        jq \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        # need zip to install terraform later
        zip \
        gettext \
    && rm -rf /var/lib/apt/lists/*

# Install python packages
RUN pip3 install awscli

# Install static binaries
RUN wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip \
    && unzip terraform_0.11.10_linux_amd64.zip -d /usr/bin/

RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl \
    && install kubectl /usr/bin

RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator \
    && install aws-iam-authenticator /usr/bin
