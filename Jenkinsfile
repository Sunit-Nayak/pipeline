pipeline {
  agent any
  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    // Create a demo Java file if none exist so the job succeeds end-to-end
    stage('Prepare sources') {
      steps {
        sh '''
set -eu
if ! find src -name "*.java" -print -quit >/dev/null 2>&1 && [ ! -f pipeline/src/Main.java ]; then
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
  echo "Using existing sources"
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
  # Compile single-file demo
  javac -d target/classes pipeline/src/Main.java
  echo "Main-Class: Main" > target/manifest.mf
else
  # Compile your real sources (Maven-style tree)
  find src/main/java -name "*.java" -print -quit >/dev/null || { echo "No Java sources found"; exit 1; }
  javac -d target/classes $(find src/main/java -name "*.java")
  # TODO: change to your real main class if different:
  echo "Main-Class: com.example.Main" > target/manifest.mf
fi

jar cfm target/myapp.jar target/manifest.mf -C target/classes .
echo "Built target/myapp.jar"
'''
      }
    }

    stage('Run JAR') {
      steps {
        sh '''
set -eu
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
