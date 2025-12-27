function fff_flip() {
    local input_file="$1"
    local direction="$2"

    if [[ -z "$input_file" ]] || [[ -z "$direction" ]]; then
        echo "Usage: fff flip <file> <horizontal|vertical>"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_flipped.${extension}"
    local filter=""

    if [[ "$direction" == "horizontal" ]]; then
        filter="hflip"
    elif [[ "$direction" == "vertical" ]]; then
        filter="vflip"
    else
        echo "❌ Direction must be 'horizontal' or 'vertical'."
        return 1
    fi

    echo "↔️  Flipping '$input_file' $direction..."
    ffmpeg -i "$input_file" -vf "$filter" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
