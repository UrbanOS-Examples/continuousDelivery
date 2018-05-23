FROM jenkins/jnlp-slave:3.19-1
USER root
ENV DEBIAN_FRONTEND noninteractive
# install dependencies for adding package repository
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-ce \
        ruby-full \
        build-essential \
    &&  rm -rf /var/lib/apt/lists/*
RUN gem install --no-ri --no-doc \
        bundler \
        inspec