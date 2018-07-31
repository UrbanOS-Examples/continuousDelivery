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

        dir('src/docker/jenkins/master') {
            stage('Jenkins Master Build') {
                def image = docker.build("scos/jenkins-master:${GIT_COMMIT_HASH}")

                if (scmVars.GIT_BRANCH == 'master') {
                    docker.withRegistry("https://199837183662.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
    }
}
