function fff_convert() {
    local input_file="$1"
    local preposition="$2"
    local format="$3"

    if [[ -z "$input_file" ]] || [[ "$preposition" != "to" ]] || [[ -z "$format" ]]; then
        echo "Usage: fff convert <file> to <format>"
        return 1
    fi

    if [[ ! -f "$input_file" ]]; then
        echo "❌ Error: File '$input_file' not found."
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local basename="${filename%.*}"
    local output_file="${basename}_output.${format}"

    echo "🎬 Converting '$input_file' to $format..."

    if [[ "$format" == "gif" ]]; then
        ffmpeg -i "$input_file" \
            -vf "fps=15,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
            -loop 0 -y "$output_file"
    elif [[ "$format" =~ ^(mp3|wav|aac|flac|ogg)$ ]]; then
        ffmpeg -i "$input_file" -vn -y "$output_file"
    else
        ffmpeg -i "$input_file" -y "$output_file"
    fi

    echo "✅ Saved to '$output_file'"
}
