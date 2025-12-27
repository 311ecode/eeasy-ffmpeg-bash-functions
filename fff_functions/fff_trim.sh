function fff_trim() {
    local input_file="$1"
    local prep_from="$2" # Expecting 'from'
    local start_time="$3"
    local prep_to="$4"   # Expecting 'to'
    local end_time="$5"

    # Validation
    if [ -z "$end_time" ] || [ "$prep_from" != "from" ] || [ "$prep_to" != "to" ]; then
        echo "Usage: fff trim <file> from <start> to <end>"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_trimmed.${extension}"

    echo "✂️  Trimming $input_file ($start_time -> $end_time)..."

    # Fast trim (copy codec)
    ffmpeg -i "$input_file" \
        -ss "$start_time" -to "$end_time" \
        -c copy \
        -y "$output_file"

    echo "✅ Saved to $output_file"
}
