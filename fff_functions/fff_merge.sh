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

    # Check for audio streams to determine merge strategy
    # Uses ffprobe to see if an audio stream exists in the inputs
    local a1=$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$file1")
    local a2=$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$file2")

    if [[ -n "$a1" ]] && [[ -n "$a2" ]]; then
        # Case A: Both files have audio. Merge Video + Audio.
        ffmpeg -i "$file1" -i "$file2" \
            -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[outv][outa]" \
            -map "[outv]" -map "[outa]" \
            -y "$output_file"
    else
        # Case B: One or both lack audio. Merge Video ONLY.
        if [[ -n "$a1" ]] || [[ -n "$a2" ]]; then
            echo "⚠️  Warning: One file lacks audio. Merging video only (audio dropped)."
        fi
        
        ffmpeg -i "$file1" -i "$file2" \
            -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[outv]" \
            -map "[outv]" \
            -y "$output_file"
    fi

    echo "✅ Saved to '$output_file'"
}
