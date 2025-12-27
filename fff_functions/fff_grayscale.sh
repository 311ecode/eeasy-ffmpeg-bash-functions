function fff_grayscale() {
    local input_file="$1"
    if [[ -z "$input_file" ]]; then echo "Usage: fff grayscale <file>"; return 1; fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_bw.${extension}"

    echo "🎞️  Applying grayscale to '$input_file'..."
    ffmpeg -i "$input_file" -vf "format=gray" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
