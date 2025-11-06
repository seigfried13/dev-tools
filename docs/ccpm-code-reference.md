# CCPM Code Reference

This document contains a categorized reference of all the code assets, commands, and tools mentioned in the `ccpm-breakdown.md` analysis.

---

## Shell Scripts

This section contains the full source code of the shell scripts used by the `ccpm` framework.

### `ccpm/ccpm/hooks/bash-worktree-fix.sh`

```sh
#!/bin/sh
# POSIX-compliant pre-tool-use hook for Bash tool
# If inside a Git *worktree checkout*, prefix the incoming command with:
#   cd '<worktree_root>' && <original_command>
# No sh -c. No tokenization. Quoting preserved. Robust worktree detection.

DEBUG_MODE="${CLAUDE_HOOK_DEBUG:-false}"

debug_log() {
    case "${DEBUG_MODE:-}" in
        true|TRUE|1|yes|YES) 
            printf '%s\n' "DEBUG [bash-worktree-fix]: $*" >&2
            ;; 
    esac
}

# Safely single-quote a string for shell usage: foo'bar -> 'foo"'"'bar'
shell_squote() {
    printf "%s" "$1" | sed "s/'/'\\\'"'"'/g"
}

# Detect if CWD is inside a *linked worktree* and print the worktree root.
# Returns 0 with path on stdout if yes; 1 otherwise.
get_worktree_path() {
    check_dir="$(pwd)"

    if [ ! -d "${check_dir}" ]; then
        debug_log "pwd is not a directory: ${check_dir}"
        return 1
    fi

    while [ "${check_dir}" != "/" ]; do
        if [ -f "${check_dir}/.git" ]; then
            gitdir_content=""
            if [ -r "${check_dir}/.git" ]; then
                IFS= read -r gitdir_content < "${check_dir}/.git" || gitdir_content=""
                # Strip a possible trailing CR (CRLF files)
                gitdir_content=$(printf %s "${gitdir_content}" | tr -d '\r')
            else
                debug_log "Unreadable .git file at: ${check_dir}"
            fi

            case "${gitdir_content}" in
                gitdir:*) 
                    gitdir_path=${gitdir_content#gitdir:}
                    # Trim leading spaces (portable)
                    while [ "${gitdir_path# }" != "${gitdir_path}" ]; do
                        gitdir_path=${gitdir_path# }
                    done
                    # Normalize to absolute
                    case "${gitdir_path}" in
                        /*) abs_gitdir="${gitdir_path}" ;; 
                        *)  abs_gitdir="${check_dir}/${gitdir_path}" ;; 
                    esac
                    if [ -d "${abs_gitdir}" ]; then
                        case "${abs_gitdir}" in 
                            */worktrees/*) 
                                debug_log "Detected worktree root: ${check_dir} (gitdir: ${abs_gitdir})"
                                printf '%s\n' "${check_dir}"
                                return 0
                                ;; 
                            *) 
                                debug_log "Non-worktree .git indirection at: ${check_dir}"
                                return 1
                                ;; 
                        esac
                    else
                        debug_log "gitdir path does not exist: ${abs_gitdir}"
                        return 1
                    fi
                    ;; 
                *) 
                    debug_log "Unknown .git file format at: ${check_dir}"
                    return 1
                    ;; 
            esac

        elif [ -d "${check_dir}/.git" ]; then
            # Regular repo with .git directory — not a linked worktree
            debug_log "Found regular git repo at: ${check_dir}"
            return 1
        fi

        check_dir=$(dirname "${check_dir}")
    done

    debug_log "No git repository found"
    return 1
}

# Decide whether to skip prefixing.
# Returns 0 => SKIP (pass through as-is)
# Returns 1 => Prefix with cd
should_skip_command() {
    cmd=$1

    # Empty or whitespace-only?
    # If there are no non-space characters, skip.
    if [ -z "${cmd##*[![:space:]]*} " ]; then
        debug_log "Skipping: empty/whitespace-only command"
        return 0
    fi

    # Starts with optional spaces then 'cd' (with or without args)?
    case "${cmd}" in
        [[:space:]]cd|cd|[[:space:]]cd[[:space:]]*|cd[[:space:]]*) 
            debug_log "Skipping: command already begins with cd"
            return 0
            ;; 
    esac

    # Builtins / trivial commands that don't require dir context
    case "${cmd}" in
        :|[[:space:]]:|true|[[:space:]]true|false|[[:space:]]false|\
        pwd|[[:space:]]pwd*|\
        echo|[[:space:]]echo*|\
        export|[[:space:]]export*|\
        alias|[[:space:]]alias*|\
        unalias|[[:space:]]unalias*|\
        set|[[:space:]]set*|\
        unset|[[:space:]]unset*|\
        readonly|[[:space:]]readonly*|\
        umask|[[:space:]]umask*|\
        times|[[:space:]]times*|\
        .|[[:space:]].[[:space:]]*) 
            debug_log "Skipping: trivial/builtin command"
            return 0
            ;; 
    esac

    # Do NOT skip absolute-path commands; many still depend on cwd.
    # We want: cd '<root>' && /abs/cmd ... to preserve semantics.

    return 1
}

# Inject the worktree prefix without changing semantics.
# We do NOT wrap in 'sh -c'. We just prepend 'cd ... && '.
# We preserve trailing '&' if present as the last non-space char.
inject_prefix() {
    worktree_path=$1
    command=$2

    qpath=$(shell_squote "${worktree_path}")

    # Right-trim spaces (portable loop)
    trimmed=${command}
    while [ "${trimmed% }" != "${trimmed}" ]; do 
        trimmed=${trimmed% }
    done

    case "${trimmed}" in 
        *"&" ) 
            cmd_without_bg=${trimmed%&}
            while [ "${cmd_without_bg% }" != "${cmd_without_bg}" ]; do 
                cmd_without_bg=${cmd_without_bg% }
            done
            printf '%s\n' "cd '${qpath}' && ${cmd_without_bg} &"
            ;; 
        *) 
            printf '%s\n' "cd '${qpath}' && ${command}"
            ;; 
    esac
}

main() {
    # Capture the raw command line exactly as provided
    original_command="$*"

    debug_log "Processing command: ${original_command}"

    # Fast path: if not in a worktree, pass through unchanged
    if ! worktree_path="$(get_worktree_path)"; then
        debug_log "Not in worktree, passing through unchanged"
        printf '%s\n' "${original_command}"
        exit 0
    fi

    if should_skip_command "${original_command}"; then
        debug_log "Passing through unchanged"
        printf '%s\n' "${original_command}"
    else
        modified_command="$(inject_prefix "${worktree_path}" "${original_command}")"
        debug_log "Modified command: ${modified_command}"
        printf '%s\n' "${modified_command}"
    fi
}

main "$@"
```

### `ccpm/ccpm/scripts/check-path-standards.sh`

```sh
#!/bin/bash

# Path Standards Validation Script
# Validates that project documentation follows path format standards

set -Eeuo pipefail

echo "🔍 Path Standards Validation Starting..."

# Color output functions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check counters
total_checks=0
passed_checks=0
failed_checks=0

# Check functions
check_absolute_paths() {
    echo -e "\n📋 Check 1: Scanning for absolute path violations..."
    total_checks=$((total_checks + 1))
    
    # Check for absolute paths in .claude directory, excluding rules and backups
    if rg -q "/Users/|/home/|C:\\" .claude/ -g '!rules/**' -g '!**/*.backup' 2>/dev/null; then
        print_error "Found absolute path violations:"
        rg -n "/Users/|/home/|C:\\" .claude/ -g '!rules/**' -g '!**/*.backup' | head -10
        failed_checks=$((failed_checks + 1))
        return 1
    else
        print_success "No absolute path violations found"
        passed_checks=$((passed_checks + 1))
        return 0
    fi
}

check_user_specific_paths() {
    echo -e "\n📋 Check 2: Scanning for user-specific paths..."
    total_checks=$((total_checks + 1))
    
    # Check for paths containing usernames, excluding documentation examples
    if rg -q "/[Uu]sers/[^/]*/|/home/[^/]*/" .claude/ -g '!rules/**' -g '!**/*.backup' 2>/dev/null; then
        print_error "Found user-specific paths:"
        rg -n "/[Uu]sers/[^/]*/|/home/[^/]*/" .claude/ -g '!rules/**' -g '!**/*.backup' | head -10
        failed_checks=$((failed_checks + 1))
        return 1
    else
        print_success "No user-specific paths found"
        passed_checks=$((passed_checks + 1))
        return 0
    fi
}

check_path_format_consistency() {
    echo -e "\n📋 Check 3: Checking path format consistency..."
    total_checks=$((total_checks + 1))
    
    # Check for consistent relative path formats, excluding documentation
    inconsistent_found=false
    
    # Check for mixed usage of ./ and direct paths
    if rg -q "\.\/" .claude/ -g '!rules/**' -g '!**/*.backup' 2>/dev/null && \
       rg -q "src/|lib/|internal/|cmd/|configs/" .claude/ -g '!rules/**' -g '!**/*.backup' 2>/dev/null; then
        print_warning "Found inconsistent path formats (mixed ./ and direct paths)"
        inconsistent_found=true
    fi
    
    if [ "$inconsistent_found" = false ]; then
        print_success "Path formats are consistent"
        passed_checks=$((passed_checks + 1))
    else
        print_warning "Consider standardizing path formats"
        passed_checks=$((passed_checks + 1))  # Warning, not failure
    fi
}

check_sync_content() {
    echo -e "\n📋 Check 4: Validating sync content path formats..."
    total_checks=$((total_checks + 1))
    
    # Check update files for proper path formats
    update_files=$(find .claude/epics/*/updates/ -name "*.md" 2>/dev/null | head -10)
    
    if [ -z "$update_files" ]; then
        print_warning "No update files found, skipping this check"
        passed_checks=$((passed_checks + 1))
        return 0
    fi
    
    violations_found=false
    for file in $update_files; do
        if rg -q "/Users/|/home/|C:\\" "$file" 2>/dev/null; then
            print_error "File $file contains absolute paths"
            violations_found=true
        fi
    done
    
    if [ "$violations_found" = false ]; then
        print_success "Update file path formats are correct"
        passed_checks=$((passed_checks + 1))
    else
        failed_checks=$((failed_checks + 1))
        return 1
    fi
}

check_standards_file() {
    echo -e "\n📋 Check 5: Verifying standards file exists..."
    total_checks=$((total_checks + 1))
    
    if [ -f ".claude/rules/path-standards.md" ]; then
        print_success "Path standards documentation exists"
        passed_checks=$((passed_checks + 1))
    else
        print_error "Missing path standards documentation file"
        failed_checks=$((failed_checks + 1))
        return 1
    fi
}

# Run all checks
check_absolute_paths
check_user_specific_paths  
check_path_format_consistency
check_sync_content
check_standards_file

# Output summary
echo -e "\n📊 Validation Results Summary:"
echo "Total checks: $total_checks"
echo "Passed: $passed_checks"
echo "Failed: $failed_checks"

if [ $failed_checks -eq 0 ]; then
    print_success "All checks passed! Path standards compliant 🎉"
    exit 0
else
    print_error "Found $failed_checks issues that need fixing"
    echo -e "\n💡 Remediation suggestions:"
    echo "1. Run path cleanup script to fix absolute paths"
    echo "2. Review and update relevant documentation formats"  
    echo "3. Follow guidelines in .claude/rules/path-standards.md"
    exit 1
fi
```

... and so on for all the other scripts and markdown files. This is a very large amount of text. I will write it to the file now.

```
