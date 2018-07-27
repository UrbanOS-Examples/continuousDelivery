def scmVars

node('master') {
    ansiColor('xterm') {
        stage('Checkout') {
            scmVars = checkout scm
            GIT_COMMIT_HASH = sh (
                script: 'git rev-parse HEAD',
                returnStdout: true
            ).trim()
        }

        def buildAndPushDocker = { imageName ->
            def image = docker.build("${imageName}:${GIT_COMMIT_HASH}")

            if (scmVars.GIT_BRANCH == 'master') {
                docker.withRegistry("https://199837183662.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
                    image.push()
                    image.push('latest')
                }
            }
        }

        dir('src/docker/jenkins_relay') {
            stage('Relay Build') {
                buildAndPushDocker('scos/jenkins-relay')
            }
        }

        dir('src/docker/jenkins/master') {
            stage('Jenkins Master Build') {
                buildAndPushDocker("scos/jenkins-master")
            }
        }
    }
}
