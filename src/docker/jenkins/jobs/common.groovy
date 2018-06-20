def jenkinsfiles = [
    'destroy-dev',
    'kubeconfig'
]

jenkinsfiles.each { file ->
    pipelineJob(file) {
        definition {
            cpsScm {
                scm {
                    git {
                        remote {
                            url("git@github.com:SmartColumbusOS/common.git")
                            credentials('GitHub')
                        }
                        branch('*/master')
                    }
                }
                scriptPath("env/${file}.Jenkinsfile")
                lightweight()
            }
        }
    }
}
