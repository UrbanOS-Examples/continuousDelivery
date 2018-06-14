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

RUN apt-get update && apt-get install -y --no-install-recommends \
	# need zip to install terraform later
	zip \
	# install dependencies for adding package repository
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    # add docker-ce repository
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -  \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" \
    # the actual tools we need
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && add-apt-repository \
    "deb http://apt.kubernetes.io/ kubernetes-xenial main" \
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-ce \
        ruby-full \
        build-essential \
        kubectl \
    &&  rm -rf /var/lib/apt/lists/*
RUN gem install --no-ri --no-doc \
        bundler \
        inspec
RUN wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
	&&  unzip terraform_0.11.7_linux_amd64.zip -d /usr/bin/
