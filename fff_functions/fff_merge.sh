function fff_merge() {
    local file1="$1"
    local and="$2"
    local file2="$3"

    if [[ -z "$file1" ]] || [[ "$and" != "and" ]] || [[ -z "$file2" ]]; then
        echo "Usage: fff merge <file1> and <file2>"
        return 1
    fi

    local basename="${file1%.*}"
    local extension="${file1##*.}"
    local output_file="${basename}_merged.${extension}"

    echo "🔗 Merging '$file1' and '$file2'..."
    
    # This filter maps [0:v][0:a][1:v][1:a] into a single output stream
    # It re-encodes to ensure the files stitch together regardless of source differences
    ffmpeg -i "$file1" -i "$file2" \
        -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[outv][outa]" \
        -map "[outv]" -map "[outa]" \
        -y "$output_file"

    echo "✅ Saved to '$output_file'"
}
