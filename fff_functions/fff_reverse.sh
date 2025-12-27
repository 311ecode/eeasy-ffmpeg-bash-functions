function fff_reverse() {
    local input_file="$1"
    if [[ -z "$input_file" ]]; then echo "Usage: fff reverse <file>"; return 1; fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_reversed.${extension}"

    echo "◀️  Reversing '$input_file'..."
    ffmpeg -i "$input_file" -vf reverse -af areverse -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
