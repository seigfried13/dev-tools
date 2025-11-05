#!/usr/bin/env node
const http = require('http');

const BACKEND_PORT = 3001;
const FRONTEND_PORT = 5173;

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[36m'
};

function checkPort(port, name) {
  return new Promise((resolve) => {
    const options = {
      hostname: 'localhost',
      port: port,
      path: '/',
      method: 'GET',
      timeout: 2000
    };

    const req = http.request(options, (res) => {
      resolve({ running: true, status: res.statusCode, name, port });
    });

    req.on('error', () => resolve({ running: false, name, port }));
    req.on('timeout', () => { req.destroy(); resolve({ running: false, name, port }); });
    req.end();
  });
}

async function checkHealth() {
  console.log(`${colors.blue}🏥 Health Check${colors.reset}\n`);

  const [backend, frontend] = await Promise.all([
    checkPort(BACKEND_PORT, 'Backend'),
    checkPort(FRONTEND_PORT, 'Frontend')
  ]);

  if (backend.running) {
    console.log(`${colors.green}✓${colors.reset} Backend: Running on port ${BACKEND_PORT}`);
  } else {
    console.log(`${colors.red}✗${colors.reset} Backend: Not running on port ${BACKEND_PORT}`);
  }

  if (frontend.running) {
    console.log(`${colors.green}✓${colors.reset} Frontend: Running on port ${FRONTEND_PORT}`);
  } else {
    console.log(`${colors.red}✗${colors.reset} Frontend: Not running on port ${FRONTEND_PORT}`);
  }

  const allRunning = backend.running && frontend.running;
  process.exit(allRunning ? 0 : 1);
}

checkHealth().catch(err => {
  console.error(`${colors.red}Error:${colors.reset}`, err.message);
  process.exit(1);
});
