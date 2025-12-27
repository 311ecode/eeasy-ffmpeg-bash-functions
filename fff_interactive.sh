#!/bin/bash

# Ensure gum is installed
if ! command -v gum &> /dev/null; then
    echo "❌ This mode requires 'gum'. Install it via: brew install gum"
    return 1
fi

function fff_interactive() {
    # 1. Select File
    local file=$(ls -p | grep -v / | gum filter --placeholder "Select a media file...")
    [ -z "$file" ] && return 0

    # 2. Select Action
    local action=$(gum choose "convert" "compress" "trim" "resize" "speed" "rotate" "flip" "mute" "stabilize" "denoise")
    [ -z "$action" ] && return 0

    case "$action" in
        convert)
            local format=$(gum choose "gif" "mp4" "mp3" "webm" "mov" "wav")
            gum spin --spinner dot --title "Processing..." -- fff convert "$file" to "$format"
            ;;
        compress)
            local size=$(gum input --placeholder "Target size (e.g. 10)")
            gum spin --spinner dot --title "Compressing..." -- fff compress "$file" to "${size}mb"
            ;;
        trim)
            local start=$(gum input --placeholder "Start time (00:00)")
            local end=$(gum input --placeholder "End time (00:10)")
            gum spin --spinner dot --title "Trimming..." -- fff trim "$file" from "$start" to "$end"
            ;;
        resize)
            local mode=$(gum choose "Preset (720p, etc)" "Custom (WxH)")
            if [[ "$mode" == "Preset"* ]]; then
                local res=$(gum choose "480p" "720p" "1080p")
                fff resize "$file" to "$res"
            else
                local dims=$(gum input --placeholder "1280x720")
                fff resize "$file" to "$dims"
            fi
            ;;
        speed)
            local dir=$(gum choose "up" "down")
            local mult=$(gum choose "1.5x" "2x" "4x")
            fff speed "$dir" "$file" by "$mult"
            ;;
        rotate)
            local deg=$(gum choose "90" "180" "270")
            fff rotate "$file" by "$deg"
            ;;
        flip)
            local axis=$(gum choose "horizontal" "vertical")
            fff flip "$file" "$axis"
            ;;
        mute|stabilize|denoise)
            gum spin --spinner dot --title "Processing..." -- "fff_$action" "$file"
            ;;
    esac
}
