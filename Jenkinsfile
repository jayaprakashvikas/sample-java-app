pipeline {
    agent any
    
    environment {
        GRADLE_HOME = tool 'Gradle' // Configure Gradle in Jenkins Global Tool Configuration
        DOCKER_REGISTRY = '767397806595.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_TAG = "${env.BUILD_NUMBER}" // Customize tag based on your requirements
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
                sh "${env.GRADLE_HOME}/bin/gradle clean build"
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
                    sh "${env.GRADLE_HOME}/bin/gradle sonarqube"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build "${env.DOCKER_REGISTRY}/sample-java-app:${env.IMAGE_TAG}"
                }
            }
        }
        
/*       stage('Push Docker Image to ECR') {
            steps {
                script {
                    docker.withRegistry('https://your-aws-account-id.dkr.ecr.your-region.amazonaws.com', 'ecr:your-ecr-credentials-id') {
                        docker.image("${env.DOCKER_REGISTRY}/your-app-name:${env.IMAGE_TAG}").push()
                    }
                }
            }
        } */
        
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
