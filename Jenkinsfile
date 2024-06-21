pipeline {
    agent any
    
    environment {
        GRADLE_HOME = tool 'Gradle' // Configure Gradle in Jenkins Global Tool Configuration   
        DOCKER_REGISTRY = '767397806595.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}" // Customize tag based on your requirements
        SONAR_AUTH_TOKEN = credentials('sonar-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh 'java -version'
                sh 'javac -version'
                sh "${env.GRADLE_HOME}/bin/gradle clean build "
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh "${env.GRADLE_HOME}/bin/gradle test"
            }
        }
        
        stage('Code Quality Scan') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${env.GRADLE_HOME}/bin/gradle sonar"
                }
            }
        }
                
    }
    
    post {
        success {
            echo 'CI/CD pipeline successfully executed!'
        }
        failure {
            echo 'CI/CD pipeline failed :('
        }
    }
}
