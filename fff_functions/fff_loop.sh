function fff_loop() {
    local input_file="$1"
    local count="$2"
    local times="$3" # "times" or "time"

    if [[ -z "$input_file" ]] || [[ -z "$count" ]]; then
        echo "Usage: fff loop <file> <number> times"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_looped.${extension}"

    echo "🔁 Looping '$input_file' $count times..."
    
    # FFmpeg's stream_loop uses 0-based index (0 means play once, 1 means repeat once)
    local loop_count=$((count - 1))
    
    ffmpeg -stream_loop "$loop_count" -i "$input_file" -c copy -y "$output_file"
    
    echo "✅ Saved to '$output_file'"
}
