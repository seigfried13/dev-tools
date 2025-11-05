#!/usr/bin/env node
const { execSync, spawn } = require('child_process');
const os = require('os');

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[36m'
};

function checkAndCleanPorts() {
  console.log(`${colors.blue}🔍 Checking ports...${colors.reset}\n`);
  // Clean up existing processes (use stop script logic)
  execSync('node scripts/stop.js', { stdio: 'inherit' });
}

function startServers() {
  console.log(`${colors.blue}🚀 Starting Services${colors.reset}\n`);
  checkAndCleanPorts();

  const platform = os.platform();
  const npmCmd = platform === 'win32' ? 'npm.cmd' : 'npm';

  const child = spawn(npmCmd, ['run', 'dev'], {
    stdio: 'inherit',
    shell: true
  });

  // Graceful shutdown
  process.on('SIGINT', () => {
    child.kill('SIGINT');
    process.exit(0);
  });

  process.on('SIGTERM', () => {
    child.kill('SIGTERM');
    process.exit(0);
  });
}

startServers();
