pipeline {
    agent any
    dir 'src/docker/jenkins_relay' {
        stages {
            stage 'Build' {
                sh 'docker build . --tag jenkins_relay:$(git rev-parse HEAD)'
            }
            stage 'Test' {
                sh 'docker run -it --rm -e MIX_ENV=test jenkins_relay:$(git rev-parse HEAD) mix test'
            }
        }
    }
}