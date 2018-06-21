node('master') {
    ansiColor('xterm') {
        stage('Checkout') {
            checkout scm
            GIT_COMMIT_HASH = sh (
                script: 'git rev-parse HEAD',
                returnStdout: true
            ).trim()
        }
        dir('src/docker/jenkins_relay') {
            stage('Relay Build') {
                buildAndPushDocker('scos/jenkins_relay')
            }
            stage('Relay Test') {
                docker.image("scos/jenkins_relay:${GIT_COMMIT_HASH}")
                    .inside('-e MIX_ENV=test') {
                        sh('mix deps.get')
                        sh('mix test')
                    }
            }
        }

        def buildAndPushDocker = { imageName ->
            docker.withRegistry("https://199837183662.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
                def image = docker.build("${imageName}:${GIT_COMMIT_HASH}")
                image.push()
                image.push('latest')
            }
        }

        dir('src/docker/jenkins/master') {
            stage('Jenkins Master Build') {
                buildAndPushDocker("scos/jenkins-master")
            }
        }

        dir('src/docker/cota-proxy') {
            stage('COTA proxy build') {
                buildAndPushDocker("scos/cota-proxy")
            }
        }
    }
}
