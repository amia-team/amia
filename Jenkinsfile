pipeline {
    agent any

    parameters {
        string(name: 'TEST_SERVER_MODULES', description: 'Path to test server modules dir (e.g. /home/amia/amia_server/test_server/modules)')
        string(name: 'LIVE_SERVER_MODULES', description: 'Path to live server modules dir (e.g. /home/amia/amia_server/server/modules)')
        choice(name: 'ENVIRONMENT', choices: ['Test', 'Live'], description: 'Target deployment environment')
        string(name: 'webhookURL', description: 'Discord webhook URL for build notifications')
    }

    stages {
        stage('Deploy Test') {
            when {
                expression {
                    return params.ENVIRONMENT == 'Test'
                }
            }
            steps {
                script {
                    if (!params.TEST_SERVER_MODULES?.trim()) {
                        error "TEST_SERVER_MODULES parameter is required for test deployment but was not set."
                    }
                }
                sh "docker run --rm -t -u \$(id -u):\$(id -g) -e NWN_HOME=\$(pwd) -v \$(pwd):\$(pwd) -v \$(pwd):/nasher cltalmadge/nasher:amia pack --clean --verbose --yes"
                sh "sudo cp Amia.mod ${params.TEST_SERVER_MODULES};"
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
                    if (!params.LIVE_SERVER_MODULES?.trim()) {
                        error "LIVE_SERVER_MODULES parameter is required for live deployment but was not set."
                    }
                    def tag = sh(script: "git tag -l 'release*' --sort=-v:refname | head -n 1", returnStdout: true).trim()
                    echo "Deploying tag: ${tag}"
                    sh "git checkout ${tag}"
                }
                sh "docker run --rm -t -u \$(id -u):\$(id -g) -e NWN_HOME=\$(pwd) -v \$(pwd):\$(pwd) -v \$(pwd):/nasher cltalmadge/nasher:amia pack --clean --verbose --yes"
                sh "sudo cp Amia.mod ${params.LIVE_SERVER_MODULES};"
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
