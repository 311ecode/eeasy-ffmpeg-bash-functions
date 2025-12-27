function fff_stabilize() {
    local input_file="$1"
    if [[ -z "$input_file" ]]; then echo "Usage: fff stabilize <file>"; return 1; fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_stabilized.${extension}"

    echo "⚖️  Stabilizing '$input_file' (using deshake)..."
    # deshake is the built-in single-pass stabilizer
    ffmpeg -i "$input_file" -vf "deshake" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
