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
