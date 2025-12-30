pipeline {
    agent any
    
    tools {
        maven 'Maven-3.9'
        jdk 'JDK-17'
    }
    
    environment {
        DOCKER_IMAGE = 'quiz-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_REGISTRY = 'your-registry' // Update with your Docker registry
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from repository...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application with Maven...'
                sh 'mvn clean compile'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'mvn test'
            }
            post {
                always {
                    // Archive test results if they exist
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package') {
            steps {
                echo 'Packaging the application...'
                sh 'mvn package -DskipTests'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Docker Push') {
            when {
                branch 'master'
            }
            steps {
                echo 'Pushing Docker image to registry...'
                script {
                    // Uncomment and configure when you have a Docker registry
                    // withDockerRegistry([credentialsId: 'docker-credentials', url: 'https://your-registry']) {
                    //     sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    //     sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
                    // }
                    echo 'Docker push stage - configure registry credentials to enable'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying application with Docker Compose...'
                script {
                    // Stop existing containers
                    sh 'docker-compose down || exit 0'
                    
                    // Start new containers
                    sh 'docker-compose up -d --build'
                    
                    // Wait for services to be healthy
                    sh 'sleep 30'
                    
                    // Check container status
                    sh 'docker-compose ps'
                }
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Performing health check...'
                script {
                    // Check if containers are running
                    sh 'docker ps | grep quizapp'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            // Uncomment to enable email notifications
            // emailext (
            //     subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            //     body: "Good news! The build ${env.BUILD_NUMBER} was successful.",
            //     to: 'your-email@example.com'
            // )
        }
        failure {
            echo 'Pipeline failed!'
            // Uncomment to enable email notifications
            // emailext (
            //     subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
            //     body: "Build ${env.BUILD_NUMBER} failed. Please check the logs.",
            //     to: 'your-email@example.com'
            // )
        }
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
