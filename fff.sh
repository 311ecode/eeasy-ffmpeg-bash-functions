#!/bin/bash

# Define the root directory relative to this script
FFF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all function files into the global namespace
if [ -d "$FFF_ROOT/fff_functions" ]; then
    for file in "$FFF_ROOT/fff_functions"/*.sh; do
        [ -e "$file" ] && source "$file"
    done
fi

function fff() {
    local action="$1"
    
    # Default to help if no action provided
    if [ -z "$action" ]; then
        fff_help
        return 0
    fi

    # Dispatcher: Construct the function name (e.g., fff_convert)
    local func_name="fff_${action}"

    # Check if the specific function exists in the namespace
    if declare -F "$func_name" > /dev/null; then
        shift # Remove the action from args
        "$func_name" "$@" # Execute specific function with remaining args
    else
        echo "❌ Unknown command: '$action'"
        echo "Try 'fff help' to see available commands."
        return 1
    fi
}
