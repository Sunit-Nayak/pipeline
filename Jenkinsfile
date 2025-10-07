pipeline {
  agent any
  options { timestamps() }
  environment {
    APP_JAR = 'target/myapp.jar'
  }
  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Compile & Package (no build tool)') {
      steps {
        sh '''
          set -euxo pipefail
          mkdir -p target/classes
          # compile all .java under src/main/java
          javac -d target/classes $(find src/main/java -name '*.java')

          # create manifest with the entrypoint
          echo "Main-Class: com.example.Main" > target/manifest.mf

          # package into a runnable jar
          jar cfm target/myapp.jar target/manifest.mf -C target/classes .
          ls -lh target/myapp.jar
        '''
      }
    }

    stage('Run JAR') {
      steps {
        sh '''
          test -f "$APP_JAR" || { echo "Jar not found: $APP_JAR"; exit 1; }
          java -jar "$APP_JAR"
        '''
      }
    }
  }
  post {
    always { archiveArtifacts artifacts: 'target/myapp.jar', allowEmptyArchive: true }
  }
}
