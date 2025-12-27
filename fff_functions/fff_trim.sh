function fff_trim() {
    local input_file="$1"
    local p_from="$2"
    local start_t="$3"
    local p_to="$4"
    local end_t="$5"

    if [[ -z "$end_t" ]] || [[ "$p_from" != "from" ]] || [[ "$p_to" != "to" ]]; then
        echo "Usage: fff trim <file> from <start> to <end>"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_trimmed.${extension}"

    echo "✂️  Trimming '$input_file'..."
    
    # Re-encoding (no -c copy) ensures the trim starts exactly on the frame requested
    ffmpeg -i "$input_file" \
        -ss "$start_t" -to "$end_t" \
        -preset superfast \
        -y "$output_file"

    echo "✅ Saved to '$output_file'"
}
