FROM jenkins/jenkins

ENV JENKINS_REF /usr/share/jenkins/ref

# install jenkins plugins
COPY plugins.txt $JENKINS_REF/
RUN /usr/local/bin/plugins.sh $JENKINS_REF/plugins.txt

ENV JAVA_OPTS -Dorg.eclipse.jetty.server.Request.maxFormContentSize=100000000 \
			  -Dhudson.diyChunking=false \
			  -Djenkins.install.runSetupWizard=false

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
    # add docker-ce and kubectl repositories
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -  \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && add-apt-repository \
        "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Install the actual apt packages we need
RUN apt-get update && apt-get install -y --no-install-recommends \
        docker-ce \
        ruby-full \
        build-essential \
        jq \
        kubectl \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        # need zip to install terraform later
        zip \
    && rm -rf /var/lib/apt/lists/*

# Install python packages
RUN pip3 install awscli

# Install ruby gems
RUN gem install --no-ri --no-doc \
    bundler \
    inspec

# Install static binaries
RUN wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
    && unzip terraform_0.11.7_linux_amd64.zip -d /usr/bin/

RUN wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws \
    && install heptio-authenticator-aws /usr/bin
