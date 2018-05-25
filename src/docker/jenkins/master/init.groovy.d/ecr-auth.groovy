import hudson.slaves.EnvironmentVariablesNodeProperty
import jenkins.model.Jenkins

// Workaround for making ECR plugin auth work properly
// https://issues.jenkins-ci.org/browse/JENKINS-44143?focusedCommentId=329498&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-329498

new File("/var/jenkins_home/.docker").mkdir()
new File("/var/jenkins_home/.docker/config.json").withWriter { out ->
    out.println '{"auths":{}}'
}

globalNodeProperties = Jenkins.get().getGlobalNodeProperties()
envVarsNodeProperties = globalNodeProperties.getAll(EnvironmentVariablesNodeProperty.class)

if ( envVarsNodeProperties == null || envVarsNodeProperties.size() == 0 ) {
  envVarsNodeProp = new EnvironmentVariablesNodeProperty();
  globalNodeProperties.add(envVarsNodeProp)
  envVars = envVarsNodeProp.getEnvVars()
} else {
  envVars = envVarsNodeProperties.get(0).getEnvVars()
}

envVars.put('DOCKER_CONFIG', '$JENKINS_HOME/.docker')

Jenkins.get().save()