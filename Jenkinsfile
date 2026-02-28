pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['Test', 'Live'], description: 'Target deployment environment')
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
                    if (!env.TEST_SERVER_MODULES?.trim()) {
                        error "TEST_SERVER_MODULES environment variable is required but was not set."
                    }
                    if (!env.AMIA_SERVER_DIR?.trim()) {
                        error "AMIA_SERVER_DIR environment variable is required but was not set."
                    }
                }
                sh "docker run --rm -t -u \$(id -u):\$(id -g) -e NWN_HOME=\$(pwd) -v \$(pwd):\$(pwd) -v \$(pwd):/nasher cltalmadge/nasher:amia pack --clean --verbose --yes"
                sh "cp Amia.mod ${env.TEST_SERVER_MODULES}/"
                withEnv(["AMIA_SERVER_DIR=${env.AMIA_SERVER_DIR}".toString()]) {
                    sh 'bash deploy-test.sh'
                }
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
                    if (!env.LIVE_SERVER_MODULES?.trim()) {
                        error "LIVE_SERVER_MODULES environment variable is required but was not set."
                    }
                    if (!env.AMIA_SERVER_DIR?.trim()) {
                        error "AMIA_SERVER_DIR environment variable is required but was not set."
                    }
                    def tag = sh(script: "git tag -l 'release*' --sort=-v:refname | head -n 1", returnStdout: true).trim()
                    echo "Deploying tag: ${tag}"
                    sh "git checkout ${tag}"
                }
                sh "docker run --rm -t -u \$(id -u):\$(id -g) -e NWN_HOME=\$(pwd) -v \$(pwd):\$(pwd) -v \$(pwd):/nasher cltalmadge/nasher:amia pack --clean --verbose --yes"
                sh "cp Amia.mod ${env.LIVE_SERVER_MODULES}/"
                withEnv(["AMIA_SERVER_DIR=${env.AMIA_SERVER_DIR}".toString()]) {
                    sh 'bash deploy-live.sh'
                }
            }
        }
    }
    post {
        success {
            echo 'Build success'
            archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            sh "rm -f Amia.mod"
        }
    }
}
