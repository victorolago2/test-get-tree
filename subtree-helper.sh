#!/bin/bash

# Git Subtree Helper Script
# This script provides utility functions for managing git subtrees

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file (optional)
CONFIG_FILE=".subtrees.conf"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_header() {
    echo -e "\n${BLUE}===================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# ============================================================================
# MAIN COMMANDS
# ============================================================================

add_subtree() {
    local prefix=$1
    local url=$2
    local branch=${3:-main}
    
    print_header "Adding Subtree"
    print_info "Prefix: $prefix"
    print_info "URL: $url"
    print_info "Branch: $branch"
    
    if git subtree add --prefix="$prefix" "$url" "$branch" --squash; then
        print_success "Subtree added successfully"
    else
        print_error "Failed to add subtree"
        return 1
    fi
}

pull_subtree() {
    local prefix=$1
    local url=$2
    local branch=${3:-main}
    
    print_header "Pulling Subtree Updates"
    print_info "Prefix: $prefix"
    print_info "Branch: $branch"
    
    if git subtree pull --prefix="$prefix" "$url" "$branch" --squash; then
        print_success "Subtree updated successfully"
    else
        print_error "Failed to update subtree"
        return 1
    fi
}

push_subtree() {
    local prefix=$1
    local url=$2
    local branch=${3:-main}
    
    print_header "Pushing Changes to Subtree"
    print_info "Prefix: $prefix"
    print_info "Target: $url:$branch"
    
    if git subtree push --prefix="$prefix" "$url" "$branch"; then
        print_success "Changes pushed successfully"
    else
        print_error "Failed to push changes"
        return 1
    fi
}

list_subtrees() {
    print_header "Configured Subtrees"
    
    if [ -f "$CONFIG_FILE" ]; then
        echo "Subtrees from $CONFIG_FILE:"
        cat "$CONFIG_FILE"
    else
        echo "No $CONFIG_FILE found"
        echo "Checking git remotes..."
        git remote -v
    fi
}

update_all() {
    print_header "Updating All Subtrees"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "No $CONFIG_FILE found"
        echo "Create a .subtrees.conf file with lines in format:"
        echo "prefix:url:branch"
        return 1
    fi
    
    local failed=0
    while IFS=':' read -r prefix url branch; do
        # Skip comments and empty lines
        [[ "$prefix" =~ ^#.*$ ]] && continue
        [[ -z "$prefix" ]] && continue
        
        branch=${branch:-main}
        print_info "Updating: $prefix"
        
        if git subtree pull --prefix="$prefix" "$url" "$branch" --squash 2>/dev/null; then
            print_success "Updated $prefix"
        else
            print_error "Failed to update $prefix"
            failed=$((failed + 1))
        fi
    done < "$CONFIG_FILE"
    
    if [ $failed -eq 0 ]; then
        print_success "All subtrees updated!"
    else
        print_error "$failed subtree(s) failed to update"
        return 1
    fi
}

remove_subtree() {
    local prefix=$1
    
    print_header "Removing Subtree"
    print_info "Prefix: $prefix"
    
    if [ ! -d "$prefix" ]; then
        print_error "Directory $prefix not found"
        return 1
    fi
    
    if git rm -r "$prefix" && git commit -m "Remove subtree: $prefix"; then
        print_success "Subtree removed successfully"
    else
        print_error "Failed to remove subtree"
        return 1
    fi
}

view_subtree_log() {
    local prefix=$1
    local limit=${2:-10}
    
    print_header "Subtree History: $prefix"
    
    if git log --oneline -n "$limit" -- "$prefix"; then
        echo ""
    else
        print_error "Failed to view log for $prefix"
        return 1
    fi
}

add_remote() {
    local name=$1
    local url=$2
    
    print_header "Adding Git Remote"
    print_info "Name: $name"
    print_info "URL: $url"
    
    if git remote add "$name" "$url"; then
        print_success "Remote added successfully"
    else
        print_error "Failed to add remote (may already exist)"
        return 1
    fi
}

status() {
    print_header "Subtree Status"
    
    if [ -f "$CONFIG_FILE" ]; then
        echo "Configured subtrees:"
        while IFS=':' read -r prefix url branch; do
            [[ "$prefix" =~ ^#.*$ ]] && continue
            [[ -z "$prefix" ]] && continue
            
            if [ -d "$prefix" ]; then
                size=$(du -sh "$prefix" | cut -f1)
                commits=$(git log --oneline -- "$prefix" | wc -l)
                echo "  • $prefix (${size}, $commits commits)"
            fi
        done < "$CONFIG_FILE"
    fi
}

# ============================================================================
# HELP
# ============================================================================

show_help() {
    cat << EOF
${BLUE}Git Subtree Helper - Usage Guide${NC}

${YELLOW}USAGE:${NC}
    $(basename "$0") <command> [options]

${YELLOW}COMMANDS:${NC}
    add <prefix> <url> [branch]
        Add a new subtree
        Example: $(basename "$0") add libs/logger https://github.com/example/logger.git main
    
    pull <prefix> <url> [branch]
        Pull updates from subtree
        Example: $(basename "$0") pull libs/logger https://github.com/example/logger.git main
    
    push <prefix> <url> [branch]
        Push changes to subtree
        Example: $(basename "$0") push libs/logger https://github.com/example/logger.git main
    
    remove <prefix>
        Remove a subtree
        Example: $(basename "$0") remove libs/logger
    
    list
        List all configured subtrees
    
    update-all
        Update all subtrees from .subtrees.conf
    
    log <prefix> [limit]
        View commit history for a subtree
        Example: $(basename "$0") log libs/logger 20
    
    status
        Show status of all subtrees
    
    add-remote <name> <url>
        Add a git remote for easier subtree operations
        Example: $(basename "$0") add-remote logger-repo https://github.com/example/logger.git
    
    help
        Show this help message

${YELLOW}CONFIGURATION FILE (.subtrees.conf):${NC}
    Create a .subtrees.conf file with lines in format:
        prefix:url:branch
    
    Example:
        libs/logger:https://github.com/example/logger.git:main
        libs/utils:https://github.com/example/utils.git:develop
        libs/test:https://github.com/example/test.git:main

${YELLOW}EXAMPLES:${NC}
    # Add a new subtree
    $(basename "$0") add-remote logging https://github.com/pinojs/pino.git
    $(basename "$0") add libs/pino logging main

    # Update all subtrees
    $(basename "$0") update-all

    # View subtree history
    $(basename "$0") log libs/pino 20

    # Push changes back to original repo
    $(basename "$0") push libs/pino logging main

EOF
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    local command=$1
    shift
    
    case "$command" in
        add)
            add_subtree "$@"
            ;;
        pull)
            pull_subtree "$@"
            ;;
        push)
            push_subtree "$@"
            ;;
        remove)
            remove_subtree "$@"
            ;;
        list)
            list_subtrees
            ;;
        update-all)
            update_all
            ;;
        log)
            view_subtree_log "$@"
            ;;
        status)
            status
            ;;
        add-remote)
            add_remote "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
