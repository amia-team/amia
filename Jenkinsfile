pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                docker {image 'urothis/nwnee-community-images:nasher-8193.34'}
            }
            steps {
                echo 'Building..'
                sh 'nasher --version'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                archiveArtifacts artifacts: 'Amia.mod', followSymlinks: false
            }
        }
    }
}