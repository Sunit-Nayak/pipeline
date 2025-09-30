pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sunit-Nayak/pipeline.git
'
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
                echo "Deplo
                
