function fff_crop() {
    local input_file="$1"
    local to="$2"
    local dim="$3"

    if [[ -z "$input_file" ]] || [[ "$to" != "to" ]] || [[ -z "$dim" ]]; then
        echo "Usage: fff crop <file> to <width>x<height>"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_cropped.${extension}"

    if [[ "$dim" =~ ^([0-9]+)x([0-9]+)$ ]]; then
        local w="${BASH_REMATCH[1]}"
        local h="${BASH_REMATCH[2]}"
        
        echo "✂️  Cropping '$input_file' to ${w}x${h}..."
        ffmpeg -i "$input_file" -vf "crop=$w:$h" -y "$output_file"
        echo "✅ Saved to '$output_file'"
    else
        echo "❌ Invalid format. Use: 640x480"
        return 1
    fi
}
