def repositories = [
    'cota-streaming-producer', 
    'cota-streaming-consumer',
    'cota-streaming-ui'
]

repositories.each { repo ->
    pipelineJob("deploy-${repo}") {
        triggers {
        	scm('H/2 * * * *')
    	}
        properties {
            parameters {
                parameterDefinitions {
                    credentials {
                        name('kubernetesCreds')
                        description('Environment to deploy to')
                        defaultValue('kubeconfig-dev')
                        credentialType('com.microsoft.jenkins.kubernetes.credentials.KubeconfigCredentials')
                        required(true)
                    }
                }
            }
        }
        definition {
            cpsScm {
                scm {
                    git {
                        remote {
                            url("git@github.com:SmartColumbusOS/${repo}.git")
                            credentials('GitHub')
                        }
                        branch('*/master')
                    }
                }
                scriptPath('Jenkinsfile.deploy')
                lightweight()
            }
        }
    }
}
