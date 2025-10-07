pipeline {
  agent any
  options { timestamps() }
  environment {
    NODE_FILE = 'app.js'
    APP_PORT  = '8081'
  }
  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Preflight: Node available?') {
      steps {
        sh '''
set -eu
if ! command -v node >/dev/null 2>&1; then
  echo "Node.js not found on this agent."
  echo "Install Node on the agent (e.g. apt install nodejs npm) OR"
  echo "configure the Jenkins NodeJS tool and add: tools { nodejs 'node18' }"
  exit 1
fi
node -v
npm -v || true
'''
      }
    }

    stage('Create demo app if missing') {
      steps {
        sh '''
set -eu
if [ ! -f "$NODE_FILE" ] && [ ! -f "server.js" ]; then
  cat > "$NODE_FILE" <<'EOF'
const http = require('http');
const port = process.env.APP_PORT || 8081;
const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Jenkins Node server\\n');
});
server.listen(port, '0.0.0.0', () => {
  console.log(`Server listening on http://localhost:${port}`);
});
EOF
  echo "Created demo $NODE_FILE"
else
  echo "Found existing Node file, using it."
fi
'''
      }
    }

    stage('Run (background)') {
      steps {
        sh '''
set -eu
# stop previous run if any
if [ -f app.pid ] && ps -p "$(cat app.pid)" >/dev/null 2>&1; then
  kill "$(cat app.pid)" || true
  sleep 1
fi

# prefer server.js if present
FILE="$NODE_FILE"
[ -f server.js ] && FILE=server.js

nohup node "$FILE" > app.log 2>&1 &
echo $! > app.pid
echo "Started Node app, PID=$(cat app.pid)"
'''
      }
    }

    stage('Health check') {
      steps {
        sh '''
set -eu
for i in $(seq 1 30); do
  if curl -fsS "http://localhost:${APP_PORT}/" >/dev/null 2>&1; then
    echo "Healthy"
    exit 0
  fi
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
      sh '''
set -eu
if [ -f app.pid ]; then
  PID=$(cat app.pid) || true
  if [ -n "${PID:-}" ] && ps -p "$PID" >/dev/null 2>&1; then
    kill "$PID" || true
    sleep 1
  fi
fi
'''
    }
  }
}
