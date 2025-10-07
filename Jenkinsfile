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
set -eu
if [ ! -d src ] || ! find src -type f -name "*.java" -print -quit | grep -q .; then
  mkdir -p pipeline/src
  cat > pipeline/src/Main.java <<'EOF'
public class Main {
  public static void main(String[] args) {
    System.out.println("Hello from Jenkins demo JAR!");
  }
}
EOF
  echo DEMO=1 > .build_mode
else
  echo DEMO=0 > .build_mode
fi
'''
      }
    }

    stage('Compile & Package') {
      steps {
        sh '''
set -eu
mkdir -p target/classes
. .build_mode || true

if [ "${DEMO:-0}" = "1" ]; then
  javac -d target/classes pipeline/src/Main.java
  echo "Main-Class: Main" > target/manifest.mf
else
  # Compile any Java files under src/ (works with or without Maven layout)
  find src -type f -name "*.java" -print -quit | grep -q .
  javac -d target/classes $(find src -type f -name "*.java")
  # TODO: change to your real entry class when you have one:
  echo "Main-Class: com.example.Main" > target/manifest.mf
fi

jar cfm target/myapp.jar target/manifest.mf -C target/classes .
ls -lh target/myapp.jar
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
      archiveArtifacts artifacts: 'target/myapp.jar', allowEmptyArchive: t
