def relayImage
def masterImage

pipeline {
    agent any

    options {
        ansiColor('xterm')
    }
    stages {

        stage('Checkout') {
            steps {
                checkout scm
                script {
                    GIT_COMMIT_HASH = sh (
                        script: 'git rev-parse HEAD',
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    dir('src/docker/jenkins_relay') {
                        relayImage = docker.build("scos/jenkins-relay:${GIT_COMMIT_HASH}")
                    }
                    dir('src/docker/jenkins/master') {
                        masterImage = docker.build("scos/jenkins-master:${GIT_COMMIT_HASH}")
                    }
                }
            }
        }

        stage('Publish') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry("https://199837183662.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:aws_jenkins_user") {
                        relayImage.push()
                        relayImage.push('latest')
                        masterImage.push()
                        masterImage.push('latest')
                    }
                }
            }
        }
    }
}