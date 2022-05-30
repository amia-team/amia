pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                 script {
                    sh "docker run --rm -t -v \$(pwd):/nasher urothis/nwnee-community-images:nasher-8193.34 pack --clean --verbose --yes"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh 'sudo cp Amia.mod /home/amia/amia_server/test_server/modules;'
                sh 'chmod +x deploy-test.sh'
                sh './deploy-test.sh'
                discordSend description: "Copy Amia Module", footer: "Pushed latest module to Test Server", result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/957814431704842270/2A6zZ4x7fsWULXnfrLLyRvgqexcnAvreXr6fbym8IoHdAHGpEoQgXjLn1XKry75uN_Zg"
            }
        }
    }
    post {
        always {
            discordSend description: "Amia module build", footer: "Build results for the Amia module", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: "https://discord.com/api/webhooks/957814431704842270/2A6zZ4x7fsWULXnfrLLyRvgqexcnAvreXr6fbym8IoHdAHGpEoQgXjLn1XKry75uN_Zg"
        }
        success {
            echo 'Build success'
            archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            sh "sudo rm -rf Amia.mod"
        }
    }
}