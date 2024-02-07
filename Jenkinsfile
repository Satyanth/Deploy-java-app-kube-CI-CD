pipeline {
    agent {
        node {
            label 'build-slave'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                sh 'echo "build stage"'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
            }
        }
        stage("Test") {
            steps {
                sh 'mvn surefire-report:report'
            }
        }
        
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'sonar-scanner'
            }
            steps {
                 withSonarQubeEnv('Sonar-Qube-Server') { // If you have configured more than one global server connection, you can specify its name
                  sh "${scannerHome}/bin/sonar-scanner"
            }
    }
  }
    }
     
}