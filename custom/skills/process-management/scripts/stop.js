#!/usr/bin/env node
const { execSync } = require('child_process');
const os = require('os');

const BACKEND_PORT = 3001;
const FRONTEND_PORT = 5173;

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[36m'
};

function findProcessOnPort(port) {
  try {
    const platform = os.platform();
    const cmd = platform === 'win32'
      ? `netstat -ano | findstr :${port}`
      : `lsof -ti:${port}`;

    const output = execSync(cmd, { encoding: 'utf8', stdio: 'pipe' });

    if (platform === 'win32') {
      const lines = output.split('\n').filter(line => line.includes('LISTENING'));
      const pids = lines.map(line => {
        const parts = line.trim().split(/\s+/);
        return parts[parts.length - 1];
      }).filter(pid => pid && pid !== '0');
      return [...new Set(pids)];
    } else {
      return output.trim().split('\n').filter(pid => pid);
    }
  } catch (error) {
    return [];
  }
}

function killProcess(pid) {
  try {
    const platform = os.platform();
    const cmd = platform === 'win32'
      ? `taskkill //F //T //PID ${pid}`
      : `kill -9 ${pid}`;
    execSync(cmd, { stdio: 'pipe' });
    return true;
  } catch (error) {
    return false;
  }
}

function stopServers() {
  console.log(`${colors.blue}🛑 Stopping Services${colors.reset}\n`);

  [BACKEND_PORT, FRONTEND_PORT].forEach(port => {
    const pids = findProcessOnPort(port);
    if (pids.length > 0) {
      pids.forEach(pid => {
        if (killProcess(pid)) {
          console.log(`${colors.green}✓${colors.reset} Killed process ${pid} on port ${port}`);
        } else {
          console.log(`${colors.red}✗${colors.reset} Failed to kill process ${pid}`);
        }
      });
    }
  });
}

stopServers();
