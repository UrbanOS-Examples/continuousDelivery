node('master') {
    String tempDir = sh(returnStdout: true, script: 'mktemp -d')
    String bucketName = "scos-alm-jenkins-backups"

    stage('Backup /var/lib/jenkins') {
        sh("tar -czf ${tempDir}/jenkins-backup.tar.gz /var/lib/jenkins")
    }

    stage('Upload backup to S3') {
        sh("aws s3 cp ${tempDir}/jenkins-backup.tar.gz s3://${bucketName}/jenkins-backup.\$(date +%F.%N).tar.gz")
    }

    stage('Cleanup') {
        sh("rm -rf ${tempDir}")
    }
}
