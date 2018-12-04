properties([pipelineTriggers([cron('0 5 * * *')])])

node('master') {
    String bucketName = "scos-alm-jenkins-backups"

    stage('Backup /var/jenkins_home to s3') {
        sh("tar --exclude '*.cache' --exclude 'caches' --exclude 'builds' --exclude 'workspace' -cz /var/jenkins_home | aws s3 cp - s3://${bucketName}/jenkins-backup.\$(date +%F.%N).tar.gz")
    }
}
