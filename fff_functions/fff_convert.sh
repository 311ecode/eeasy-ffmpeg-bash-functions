function fff_convert() {
    local input_file="$1"
    local preposition="$2" # Expecting 'to'
    local format="$3"

    # Validation
    if [ -z "$input_file" ] || [ "$preposition" != "to" ] || [ -z "$format" ]; then
        echo "Usage: fff convert <file> to <format>"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_output.${format}"

    echo "🎬 Converting $input_file to $format..."

    if [ "$format" == "gif" ]; then
        # Specialized GIF generation (High quality palette gen)
        ffmpeg -i "$input_file" \
            -vf "fps=15,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
            -loop 0 -y "$output_file"
    elif [[ "$format" =~ ^(mp3|wav|aac|flac|ogg)$ ]]; then
        # Audio extraction
        ffmpeg -i "$input_file" -vn -y "$output_file"
    else
        # Standard Video conversion
        ffmpeg -i "$input_file" -y "$output_file"
    fi

    echo "✅ Saved to $output_file"
}
