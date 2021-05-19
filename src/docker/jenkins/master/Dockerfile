FROM jenkins/jenkins:2.277.4-lts

ARG docker_config
ENV DOCKER_CONFIG=${docker_config}
COPY config.json ${docker_config}/config.json

ENV JENKINS_REF /usr/share/jenkins/ref

# install jenkins plugins
COPY plugins.txt $JENKINS_REF/
RUN jenkins-plugin-cli --latest false -f $JENKINS_REF/plugins.txt

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
