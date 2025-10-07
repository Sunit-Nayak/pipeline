pipeline {
  agent any
  tools { jdk 'jdk17' }
  stages {
    stage('Run JAR') {
      steps {
        sh 'java -version'
        sh 'java -jar target/myapp.jar'
      }
    }
  }
}
