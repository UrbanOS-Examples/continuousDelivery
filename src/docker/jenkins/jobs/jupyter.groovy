def jenkinsfiles = [
    'jupyter-notebook-scipy',
]

def repository = { pipeline_file ->
    return {
        scm {
            git {
                remote {
                    url("git@github.com:SmartColumbusOS/jupyterhub.git")
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
            cpsScm repository("notebooks/${file}.Jenkinsfile")
        }
    }
}
