def jenkinsfiles = [
    'jenkins-backup'
]

jenkinsfiles.each { file ->
    pipelineJob(file) {
        definition {
            cps {
                script(readFileFromWorkspace("${file}.Jenkinsfile"))
            }
        }
    }
}
