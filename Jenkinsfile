pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                 script {
                    sh "docker run --rm -t -v \$(pwd):/nasher urothis/nwnee-community-images:nasher-8193.34 pack --clean --verbose --default"
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
            cleanWs()
            discordSend description: "Amia module build", footer: "Build results for the Amia module", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/957814431704842270/2A6zZ4x7fsWULXnfrLLyRvgqexcnAvreXr6fbym8IoHdAHGpEoQgXjLn1XKry75uN_Zg"
        }
        success {
            echo 'Build success'
            archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            sh "sudo rm -rf Amia.mod"
        }
    }
}