node('master') {
    ansiColor('xterm') {
        stage('Checkout') {
            env.GIT_COMMIT_HASH = checkout(scm).GIT_COMMIT
        }

        dir('src/docker/jenkins/master') {
            stage('Jenkins Master Build') {
                def image = docker.build("scos/jenkins-master:${env.GIT_COMMIT_HASH}")

                if (env.BRANCH_NAME == 'master') {
                    docker.withRegistry("https://199837183662.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
    }
}
