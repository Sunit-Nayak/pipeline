
pipeline {
  agent any
  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Prepare sources') {
      steps {
        sh '''
# Create a demo source only if no Java files exist in src/
if ! find src -type f -name "*.java" -print -quit 2>/dev/null | grep -q .; then
  mkdir -p pipeline/src
  cat > pipeline/src/Main.java <<'EOF'
public class Main {
  public static void main(String[] args) {
    System.out.println("Hello from Jenkins demo JAR!");
  }
}
EOF
  echo "Created demo source at pipeline/src/Main.java"
else
  echo "Using existing sources under src/"
fi
'''
      }
    }

    stage('Compile & Package') {
      steps {
        sh '''
set -eu
mkdir -p target/classes

if [ -f pipeline/src/Main.java ]; then
  # Demo single-file build
  javac -d target/classes pipeline/src/Main.java
  echo "Main-Class: Main" > target/manifest.mf
else
  # Generic compile for any src/* Java tree
  SRC_LIST="$(find src -type f -name "*.java")"
  [ -n "$SRC_LIST" ] || { echo "No Java sources found"; exit 1; }
  javac -d target/classes $SRC_LIST
  # TODO: change to your actual entry class when you have one:
  echo "Main-Class: com.example.Main" > target/manifest.mf
fi

jar cfm target/app.jar target/manifest.mf -C target/classes .
ls -lh target/app.jar
'''
      }
    }

    stage('Run JAR') {
      steps {
        sh 'java -jar target/app.jar'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'target/app.jar', allowEmptyArchive: true
    }
  }
}
