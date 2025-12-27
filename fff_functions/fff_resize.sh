function fff_resize() {
    local input_file="$1"
    local preposition="$2"
    local dimension="$3"

    if [[ -z "$input_file" ]] || [[ "$preposition" != "to" ]] || [[ -z "$dimension" ]]; then
        echo "Usage: fff resize <file> to <width>x<height> OR <preset>p"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_output.${extension}"
    local scale_filter=""

    if [[ "$dimension" =~ ^([0-9]+)p$ ]]; then
        # Preset mode: e.g., 720p
        local height="${BASH_REMATCH[1]}"
        scale_filter="scale=-2:${height}"
    elif [[ "$dimension" =~ ^([0-9]+)x([0-9]+)$ ]]; then
        # Custom mode: e.g., 1280x720
        scale_filter="scale=${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
    else
        echo "❌ Invalid dimension format. Use 1280x720 or 720p."
        return 1
    fi

    echo "📐 Resizing '$input_file' to $dimension..."
    ffmpeg -i "$input_file" -vf "$scale_filter" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
