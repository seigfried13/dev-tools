---
name: process-management
description: Node.js development server lifecycle management including start/stop/health scripts, port conflict resolution, and process monitoring. Use when users mention port conflicts (EADDRINUSE), server management, health checks, process issues, or can't start development servers. Triggers include "port in use", "EADDRINUSE", "address already in use", "server won't start", "can't start server", "kill process", "stop server", "restart server", "health check", "server status", "start/stop scripts", "process management", "port conflict", "port 3000", "port 5173", or any Node.js/npm server lifecycle issues.
---

# Process Management Skill

## 1. At a Glance

This skill helps you manage the lifecycle of your Node.js development servers. It provides scripts and patterns for starting, stopping, and checking the health of your application.

**Use this skill to:**
*   Fix port conflicts (EADDRINUSE errors).
*   Create reliable start/stop/restart scripts.
*   Implement server health checks.

## 2. Quick Start: `package.json` Scripts

Add the following scripts to your `package.json` to get started:

```json
{
  "scripts": {
    "start": "node scripts/start.js",
    "stop": "node scripts/stop.js",
    "restart": "node scripts/restart.js",
    "health": "node scripts/health.js"
  }
}
```

*   `npm start`: Starts the development servers and cleans up any conflicting processes.
*   `npm stop`: Stops all running development servers.
*   `npm run restart`: Restarts the development servers.
*   `npm run health`: Checks if the servers are running and responsive.

---

## 3. Common Scenarios

### Port Conflict (`EADDRINUSE`)

If you see an "address already in use" error, it means another process is using the port your application needs.

**Solution:**

1.  **Stop the conflicting process:**
    ```bash
    npm run stop
    ```
2.  **Restart the application:**
    ```bash
    npm start
    ```

### Server Not Responding

If your application is running but not responding, use the health check to diagnose the issue.

```bash
npm run health
```

This will tell you which server (frontend or backend) is having trouble.

---

## 4. Best Practices

*   **Cross-Platform**: Use `os.platform()` to write scripts that work on Windows, macOS, and Linux.
*   **Graceful Shutdown**: Always handle `SIGINT` and `SIGTERM` signals to ensure your application shuts down cleanly.
*   **Clear Feedback**: Use color-coded console output to make your scripts easy to read.

---

## 5. Troubleshooting

| Issue | Solution |
| :--- | :--- |
| **Process won't die** | Use a force flag (`/F /T` on Windows, `-9` on Unix) to kill the process. |
| **Permission denied** | On Linux/macOS, you may need `sudo` to use ports below 1024. |
| **Port still in use** | Wait a few seconds for the OS to release the port. If the problem persists, you may need to restart your machine. |

---

## 6. Scripts

The full code for the scripts can be found in the `scripts` directory:

*   [`scripts/health.js`](./scripts/health.js)
*   [`scripts/stop.js`](./scripts/stop.js)
*   [`scripts/start.js`](./scripts/start.js)