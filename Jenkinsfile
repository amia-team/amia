pipeline {
    agent any

    stages {
        stage('Deploy Test') {
            when {
                expression {
                    return params.ENVIRONMENT == 'Test'
                }
            }
            steps {
                script {
                    def tag = sh(script: "git tag -l 'test-release*' --sort=-v:refname | head -n 1", returnStdout: true).trim()
                    echo "Deploying tag: ${tag}"
                    sh "git checkout ${tag}"
                }
                sh "docker run --rm -t -u \$(id -u):\$(id -g) -e NWN_HOME=\$(pwd) -v \$(pwd):\$(pwd) -v \$(pwd):/nasher cltalmadge/nasher:1.1.1 pack --clean --verbose --yes"
                sh 'sudo cp Amia.mod /home/amia/amia_server/test_server/modules;'
                sh 'chmod +x deploy-test.sh'
                sh './deploy-test.sh'
            }
        }
        stage('Deploy Live') {
            when {
                expression {
                    return params.ENVIRONMENT == 'Live'
                }
            }
            steps {
                script {
                    def tag = sh(script: "git tag -l 'release*' --sort=-v:refname | head -n 1", returnStdout: true).trim()
                    echo "Deploying tag: ${tag}"
                    sh "git checkout ${tag}"
                }
                sh "docker run --rm -t -u \$(id -u):\$(id -g) -e NWN_HOME=\$(pwd) -v \$(pwd):\$(pwd) -v \$(pwd):/nasher cltalmadge/nasher:1.1.1 pack --clean --verbose --yes"
                sh 'sudo cp Amia.mod /home/amia/amia_server/server/modules;'
                sh 'chmod +x deploy-live.sh'
                sh './deploy-live.sh'
            }
        }
    }
    post {
        always {
             discordSend description: "Builder for Amia module finished.", footer: "Build results for Amia module", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: params.webhookURL
        }
        success {
            echo 'Build success'
            archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            sh "sudo rm -rf Amia.mod"
        }
    }
}