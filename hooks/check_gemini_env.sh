#!/bin/bash

# This script runs on SessionStart to validate the full Gemini/Context7 environment.

# --- Helper Functions ---

# Prints a fatal error to stderr (for the user) and exits.
print_error() {
  echo "---" >&2
  echo "⛔ ENVIRONMENT CHECK FAILED: $1" >&2
  echo "   REASON: $2" >&2
  echo "   ACTION: $3" >&2
  echo "---" >&2
  exit 1
}

# Prints a non-fatal warning to stdout (for Claude AND the user).
print_warning() {
  echo "---"
  echo "⚠️ ENVIRONMENT WARNING: $1"
  echo "   REASON: $2"
  echo "   ACTION: $3"
  echo "---"
}

# Prints a success message to stdout (for Claude's context).
print_info() {
  echo "✅ Environment Verified: $1"
}

# --- Validation Functions ---

# 1. Check for gemini-cli and set $GEMINI_CMD
check_gemini_cli() {
  if command -v gemini &> /dev/null; then
    # Found global install
    GEMINI_CMD="gemini"
    print_info "gemini-cli found in PATH."
    return 0
  elif [ -f "./node_modules/.bin/gemini" ]; then
    # Found local project install
    GEMINI_CMD="./node_modules/.bin/gemini"
    print_info "gemini-cli found in local node_modules."
    return 0
  fi

  # --- Not found, so we prompt the user ---
  echo "---" >&2
  echo "⚠️  gemini-cli command not found." >&2
  echo "   Please choose an option:" >&2
  echo "   1) Run with npx (NOTE: Skills calling 'gemini' directly will fail!)" >&2
  echo "   2) Install to project (npm install -D @google/gemini-cli)" >&2
  echo "   3) Quit" >&2
  
  # Read from the user's actual terminal, not stdin
  read -p "   Enter choice (1-3): " choice < /dev/tty

  case $choice in
    1)
      # User chose npx.
      print_warning "Continuing with 'npx'..." \
        "The 'gemini-cli-collaboration' skill will FAIL because it calls 'gemini' directly." \
        "You must manually edit the skill to use 'npx @google/gemini-cli ...' instead."
      # We don't set $GEMINI_CMD because it's not a direct command.
      # We'll skip the extension check, as we can't run it.
      SKIP_EXT_CHECK=true
      ;;
    2)
      # User chose to install.
      echo "Installing @google/gemini-cli as a dev dependency..." >&2
      if npm install -D @google/gemini-cli; then
        echo "Install successful." >&2
        # Now we set the command path
        GEMINI_CMD="./node_modules/.bin/gemini"
        print_info "gemini-cli installed locally."
      else
        print_error "npm install failed." "Could not install @google/gemini-cli." "Please install it manually and restart."
      fi
      ;;
    3)
      # User chose to quit.
      echo "Quitting." >&2
      exit 1
      ;;
    *)
      print_error "Invalid choice." "Received '$choice'." "Please restart and select 1, 2, or 3."
      ;;
  esac
}

# 2. Check for installed extensions
check_extensions() {
  if [ "$SKIP_EXT_CHECK" = true ]; then
    print_warning "Skipping extension check." "Cannot verify extensions without an installed 'gemini' command." "N/A"
    return 0
  fi

  echo "Checking for extensions..." >&2
  EXT_LIST=$($GEMINI_CMD --list-extensions)
  MISSING_EXT=false

  # Check for Jules
  if ! echo "$EXT_LIST" | grep -q "jules"; then
    print_error "Extension 'jules' not found." \
      "The 'jules' extension is required." \
      "Run: $GEMINI_CMD extensions install https://github.com/gemini-cli-extensions/jules"
    MISSING_EXT=true
  fi
  
  # Check for Context7
  if ! echo "$EXT_LIST" | grep -q "context7"; then
    print_error "Extension 'context7' not found." \
      "The 'context7' extension is required." \
      "Run: $GEMINI_CMD extensions install https://github.com/upstash/context7"
    MISSING_EXT=true
  fi
  
  # Check for GitHub
  if ! echo "$EXT_LIST" | grep -q "github"; then
    print_error "Extension 'github' not found." \
      "The 'github' extension is required." \
      "Run: $GEMINI_CMD extensions install https://github.com/github/github-mcp-server"
    MISSING_EXT=true
  fi

  if [ "$MISSING_EXT" = true ]; then
    exit 1 # Exit due to missing extensions
  fi

  print_info "All required extensions (jules, context7, github) are installed."
}

# 3. Check for MCP configuration
check_mcp() {
  # Check all possible settings files
  if ! grep -q "\"context7\"" .claude/settings.json .claude/settings.local.json ~/.claude/settings.json 2>/dev/null; then
    print_error "'context7' MCP server is not configured in Claude Code." \
      "The 'context7' MCP server must be registered in your settings." \
      "Please use the '/mcp' command or edit your settings.json to add it."
  fi
  print_info "'context7' MCP server is configured in Claude Code."
}

# --- Main Execution ---
check_gemini_cli
check_extensions
check_mcp

# If all checks passed, print a final success message
echo "---"
echo "✅ Full Gemini Environment Verified"
echo "   Ready for collaboration."
echo "---"
exit 0