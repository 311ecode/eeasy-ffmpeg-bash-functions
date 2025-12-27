function fff_compress() {
    local input_file="$1"
    local preposition="$2" # Expecting 'to'
    local target_str="$3"  # Expecting '10mb', '5mb' etc

    # Validation
    if [ -z "$input_file" ] || [ "$preposition" != "to" ] || [ -z "$target_str" ]; then
        echo "Usage: fff compress <file> to <size>mb"
        return 1
    fi

    # Strip non-numeric chars to get integer size
    local size_int=$(echo "$target_str" | tr -dc '0-9')

    if [ -z "$size_int" ]; then
        echo "❌ Invalid size format. Use '10mb', '20mb' etc."
        return 1
    fi

    # Determine CRF based on target size (Simple Logic)
    # Smaller size = Higher CRF (lower quality)
    local crf=23 # Default
    if [ "$size_int" -le 5 ]; then
        crf=32
    elif [ "$size_int" -le 10 ]; then
        crf=28
    elif [ "$size_int" -le 20 ]; then
        crf=26
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_compressed.${extension}"

    echo "📦 Compressing $input_file (Target ~$size_int MB, CRF $crf)..."

    ffmpeg -i "$input_file" \
        -c:v libx264 -crf $crf -preset medium \
        -c:a aac -b:a 128k \
        -y "$output_file"

    echo "✅ Saved to $output_file"
}
