function fff_compress() {
    local input_file="$1"
    local preposition="$2"
    local target_str="$3"

    if [[ -z "$input_file" ]] || [[ "$preposition" != "to" ]] || [[ -z "$target_str" ]]; then
        echo "Usage: fff compress <file> to <size>mb"
        return 1
    fi

    local size_int=$(echo "$target_str" | tr -dc '0-9')
    local crf=23
    [[ "$size_int" -le 20 ]] && crf=26
    [[ "$size_int" -le 10 ]] && crf=28
    [[ "$size_int" -le 5 ]] && crf=32

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_compressed.${extension}"

    echo "📦 Compressing '$input_file'..."
    ffmpeg -i "$input_file" -c:v libx264 -crf $crf -preset medium -c:a aac -b:a 128k -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
