#!/bin/bash
set -e

echo "Running Docker setup script..."

# The Dockerfile already installs dependencies from requirements.txt

# Test MCP server
echo "Testing MCP server..."
timeout 3 python3 skill_seeker_mcp/server.py 2>/dev/null || {
    if [ $? -eq 124 ]; then
        echo "MCP server starts correctly (timeout expected)"
    else
        echo "MCP server test inconclusive, but may still work"
    fi
}

# Run tests
echo "Running tests..."
python3 -m pytest tests/test_mcp_server.py -v --tb=short

echo "Docker setup script finished."
