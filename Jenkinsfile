pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                sh 'echo $PATH'
                sh '/opt/apache-maven-3.9.6/bin/mvn clean deploy'
            }
        }
    }
}
