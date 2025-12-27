function fff_rotate() {
    local input_file="$1"
    local by="$2"
    local degrees="$3"

    if [[ -z "$input_file" ]] || [[ "$by" != "by" ]] || [[ -z "$degrees" ]]; then
        echo "Usage: fff rotate <file> by <90|180|270>"
        return 1
    fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_rotated.${extension}"
    local transpose=""

    case "$degrees" in
        90)  transpose="transpose=1" ;;
        180) transpose="transpose=1,transpose=1" ;;
        270) transpose="transpose=2" ;;
        *)
            echo "❌ Supported rotation: 90, 180, 270 degrees."
            return 1
            ;;
    esac

    echo "🔄 Rotating '$input_file' by $degrees°..."
    ffmpeg -i "$input_file" -vf "$transpose" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
