node('master') {
    ansiColor('xterm') {
        stage('Checkout') {
            env.GIT_COMMIT_HASH = checkout(scm).GIT_COMMIT
        }

        dir('src/docker/jenkins/master') {
            stage('Jenkins Master Build') {
                buildAndPushDocker("scos/jenkins-master", "Dockerfile")
            }
        }

        dir('src/docker/jenkins_workers') {
            stage('Jenkins Workers Build - Terraform') {
                buildAndPushDocker("scos/jenkins-worker-terraform", "Dockerfile.terraform")
            }
            stage('Jenkins Workers Build - Kubernetes') {
                buildAndPushDocker("scos/jenkins-worker-kubernetes", "Dockerfile.kubernetes")
            }
        }
    }
}

def buildAndPushDocker(imageName, dockerFilePath) {
    def image = docker.build("${imageName}:${env.GIT_COMMIT_HASH}", "-f ${dockerFilePath} .")

    if (env.BRANCH_NAME == 'master') {
        docker.withRegistry("https://199837183662.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
            image.push()
            image.push('latest')
        }
    }
}
