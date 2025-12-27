function fff_denoise() {
    local input_file="$1"
    if [[ -z "$input_file" ]]; then echo "Usage: fff denoise <file>"; return 1; fi

    local filename=$(basename -- "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    local output_file="${basename}_denoised.${extension}"

    echo "🧹 Reducing noise in '$input_file'..."
    # hqdn3d is a high-grade 3D denoiser (temporal + spatial)
    ffmpeg -i "$input_file" -vf "hqdn3d" -y "$output_file"
    echo "✅ Saved to '$output_file'"
}
