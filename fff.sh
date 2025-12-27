#!/bin/bash

function fff() {
    local action="$1"
    
    # Default to help
    if [ -z "$action" ]; then
        action="help"
    fi

    # Construct function name
    local func_name="fff_${action}"

    # Check if the function exists in the namespace (loaded by loader)
    if declare -F "$func_name" > /dev/null; then
        # Remove the action argument, unless it's help (optional preference)
        if [ "$action" != "help" ]; then
            shift
        fi
        "$func_name" "$@"
    else
        echo "❌ Unknown command: '$action'"
        echo "   (Ensure you have sourced 'loader')"
        return 1
    fi
}
