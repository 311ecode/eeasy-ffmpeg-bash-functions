function fff_speed() {
    local direction="$1" # 'up' or 'down'
    local input_file="$2"
    local by="$3"
    local factor_raw="$4"

    if [[ -z "$factor_raw" ]]; then
        echo "Usage: fff speed <up|down> <file> by <multiplier>x"
        return 1
    fi

    local factor=$(echo "$factor_raw" | tr -d 'x')
    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_speed.${extension}"

    local v_filter=""
    local a_filter=""

    if [[ "$direction" == "up" ]]; then
        # Video: 2x faster means PTS/2
        v_filter="setpts=PTS/${factor}"
        # Audio: atempo is max 2.0 per instance
        a_filter="atempo=${factor}"
    else
        v_filter="setpts=PTS*${factor}"
        a_filter="atempo=1/${factor}"
    fi

    echo "⚡ Changing speed of '$input_file'..."
    ffmpeg -i "$input_file" -vf "$v_filter" -af "$a_filter" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
