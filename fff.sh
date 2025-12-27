#!/bin/bash

# Define the root directory relative to this script
FFF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function fff() {
    local action="$1"
    
    # 1. Interactive Mode Check
    # If no arguments are passed, try to launch gum-based interactive mode
    if [ -z "$action" ]; then
        if command -v gum &> /dev/null; then
            fff_interactive
            return $?
        else
            fff_help
            return 0
        fi
    fi

    # 2. Command Dispatcher
    # Map 'fff speed' to 'fff_speed', etc.
    local func_name="fff_${action}"

    if declare -F "$func_name" > /dev/null; then
        shift # Remove action name from arguments
        "$func_name" "$@"
    else
        echo "❌ Unknown command: '$action'"
        echo "Try 'fff help' to see available commands."
        return 1
    fi
}
