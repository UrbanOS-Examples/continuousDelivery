node('master') {
    stage('Checkout') {
        checkout scm
        GIT_COMMIT_HASH = sh (
            script: 'git rev-parse HEAD',
            returnStdout: true
        ).trim()
    }
    dir('src/docker/jenkins_relay') {
        stage('Build') {
            docker.build("scos/jenkins_relay:${GIT_COMMIT_HASH}")
        }
        stage('Test') {
            docker.image("scos/jenkins_relay:${GIT_COMMIT_HASH}")
                .inside('-e MIX_ENV=test') {
                    sh('mix deps.get')
                    sh('mix test')
                }
        }
    }
}
