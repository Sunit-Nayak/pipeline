pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sunit-Nayak/pipeline/new/main/pipeline.git'
            }
        }

        stage('Build') {
            steps {
                echo "Building the project..."
                sh 'echo "Compile code here (Maven/Gradle/npm)"'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh 'echo "Run unit tests here"'
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying application..."
                sh 'echo "Deploy to staging server or container here"'
            }
        }
    }

    post {
        success {
            echo "Build succeeded!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
