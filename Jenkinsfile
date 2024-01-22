pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    stages {
        stage('Clone code from GitHub') {
            steps {
                git url: 'https://github.com/Satyanth/DevopsProject.git'
            }
        }
    }
}
