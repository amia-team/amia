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
        stage('Deploy Test') {
            when {
                expression {
                    return params.ENVIRONMENT == 'Test'
                }
            }
            steps {
                echo 'Deploying....'
                sh 'sudo cp Amia.mod /home/amia/amia_server/test_server/modules;'
                sh 'chmod +x deploy-test.sh'
                sh './deploy-test.sh'
                discordSend description: "Copy Amia Module to Test", footer: "Pushed latest module to Test Server", result: currentBuild.currentResult, title: "Test Server Deployment", webhookURL: "https://discord.com/api/webhooks/957814431704842270/2A6zZ4x7fsWULXnfrLLyRvgqexcnAvreXr6fbym8IoHdAHGpEoQgXjLn1XKry75uN_Zg"
            }
        }
        stage('Deploy Live') {
            when {
                expression {
                    return params.ENVIRONMENT == 'Live'
                }
            }
            steps {
                sh 'sudo cp Amia.mod /home/amia/amia_server/server/modules;'
                sh 'chmod +x deploy-live.sh'
                sh './deploy-live.sh'
                discordSend description: "Deploy Amia Module to Live", footer: "Deployed latest module to Live Server", result: currentBuild.currentResult, title: "Live Server Deployment", webhookURL: "https://discord.com/api/webhooks/957814431704842270/2A6zZ4x7fsWULXnfrLLyRvgqexcnAvreXr6fbym8IoHdAHGpEoQgXjLn1XKry75uN_Zg"
            }
        }
    }
    post {
        always {
            discordSend description: "Build complete for: $env.GIT_COMMITTER_NAME\nCommit summary:$env.CHANGE_TITLE\n$env.GIT_COMMIT_MSG", footer: "Build results for the Amia module", link: env.BUILD_URL, result: currentBuild.currentResult, title: "Module Deployment Results (click to see more)", webhookURL: "https://discord.com/api/webhooks/957814431704842270/2A6zZ4x7fsWULXnfrLLyRvgqexcnAvreXr6fbym8IoHdAHGpEoQgXjLn1XKry75uN_Zg"
        }
        success {
            echo 'Build success'
            archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            sh "sudo rm -rf Amia.mod"
        }
    }
}