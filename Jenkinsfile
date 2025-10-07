pipeline {
  agent any
  options { timestamps() }
  tools { nodejs 'node18' }   // <- the name you configured

  environment {
    NODE_FILE = 'app.js'      // change if your file is e.g. server.js
    APP_PORT  = '8081'        // change to your app's port
  }

  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Install deps') {
      steps {
        sh '''
set -eu
if [ -f package-lock.json ]; then
  npm ci
elif [ -f package.json ]; then
  npm install
else
  echo "No package.json found — skipping install"
fi
'''
      }
    }

    stage('Run (background)') {
      steps {
        sh '''
set -eu
[ -f "$NODE_FILE" ] || { echo "Missing $NODE_FILE"; exit 1; }

# stop previous run if still alive
if [ -f app.pid ] && ps -p "$(cat app.pid)" >/dev/null 2>&1; then
  kill "$(cat app.pid)" || true
  sleep 2
fi

# start in background; log to file
nohup node "$NODE_FILE" > app.log 2>&1 &
echo $! > app.pid
echo "Started Node app, PID=$(cat app.pid)"
'''
      }
    }

    stage('Health check') {
      steps {
        sh '''
# change the URL to your real health endpoint if needed
for i in $(seq 1 30); do
  curl -fsS "http://localhost:${APP_PORT}/" && exit 0
  sleep 1
done
echo "App did not become healthy"; exit 1
'''
      }
    }
  }

  post {
    always { archiveArtifacts artifacts: 'app.log', allowEmptyArchive: true }
    cleanup {
      // stop background app so the agent is clean
      sh '''
if [ -f app.pid ]; then
  PID=$(cat app.pid) || true
  if [ -n "$PID" ] && ps -p "$PID" >/dev/null 2>&1; then
