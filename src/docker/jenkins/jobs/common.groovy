def jenkinsfiles = [
    'destroy-dev',
    'deploy-dev'
]

def repository = { pipeline_file ->
    return { 
        scm {
            git {
                remote {
                    url("git@github.com:SmartColumbusOS/common.git")
                    credentials('GitHub')
                }
                branch('*/master')
            }
        }
        scriptPath("${pipeline_file}")
        lightweight()
    }
}

jenkinsfiles.each { file ->
    pipelineJob(file) {
        definition {
            cpsScm repository("env/${file}.Jenkinsfile")
        }
    }
}

pipelineJob('deploy-proxy-cluster') {
    definition {
        cpsScm repository("alm/proxy-cluster.Jenkinsfile")
    }
}