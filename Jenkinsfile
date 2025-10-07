pipeline {
  agent any
  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Compile & Package (no build tool)') {
      steps {
        sh '''#!/usr/bin/env bash
set -euo pipefail
mkdir -p target/classes

# ensure we have sources
if ! find src/main/java -name '*.java' -print -quit | grep -q .; then
  echo "No .java sources under src/main/java"; exit 1
fi

# compile
javac -d target/classes $(find src/main/java -name '*.java')

# add a manifest with the entry point (change if your main class differs)
echo "Main-Class: com.example.Main" > target/manifest.mf

# create runnable jar
jar cfm target/myapp.jar target/manifest.mf -C target/classes .
ls -lh target/myapp.jar
'''
      }
    }

    stage('Run JAR') {
      steps {
        sh '''#!/usr/bin/env bash
set -euo pipefail
test -f target/myapp.jar || { echo "Jar not found"; exit 1; }
java -jar target/myapp.jar
'''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'target/myapp.jar', allowEmptyArchive: true
    }
  }
}

