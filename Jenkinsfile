pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                 script {
                    sh "docker run --rm -t -v \$(pwd):/nasher urothis/nwnee-community-images:nasher-8193.34 pack --clean --verbose"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
               
            }
        }
        
    }
    post {
        always {
            discordSend description: "Amia module build", footer: "Footer Text", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/957694023575928893/IMYITwBo8EEsJDrvgHlBlkOX0TogzYDpyZrXv-aX90koavyRDoAkmSUURbxdCEeU0gzx"
        }
        success {
            echo 'Build success'
            archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            sh "sudo rm -rf Amia.mod"
        }
    }
}