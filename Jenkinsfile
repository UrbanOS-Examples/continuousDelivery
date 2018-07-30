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

        def buildAndPushDocker = { imageName, dockerFilePath="Dockerfile" ->
            def image = docker.build("${imageName}:${GIT_COMMIT_HASH}", dockerFilePath)

            if (scmVars.GIT_BRANCH == 'master') {
                docker.withRegistry("https://068920858268.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
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
