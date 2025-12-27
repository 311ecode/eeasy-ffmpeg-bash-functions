#!/usr/bin/env bash

testFFF() {
  export LC_NUMERIC=C

  setupTestAssets() {
    echo "🎬 Generating 2s B&W Test Asset..."
    ffmpeg -f lavfi -i color=c=black:s=64x64:d=1 -c:v libx264 -loglevel error -y black.mp4
    ffmpeg -f lavfi -i color=c=white:s=64x64:d=1 -c:v libx264 -loglevel error -y white.mp4
    
    echo "file 'black.mp4'" > list.txt
    echo "file 'white.mp4'" >> list.txt
    ffmpeg -f concat -safe 0 -i list.txt -c copy -loglevel error -y "combined.mp4"
    cp "combined.mp4" "space video.mp4"
    rm list.txt black.mp4 white.mp4
  }

  cleanupArtifacts() {
    if [[ "$DEBUG" == "true" ]]; then
        echo "🔍 DEBUG mode active: Skipping cleanup of artifacts."
        return 0
    fi
    echo "🧹 Cleaning up..."
    rm -f combined.mp4 "space video.mp4" *.gif *.png *_output.* *_compressed.* *_trimmed.*
  }

  check_color() {
    local file="$1"
    local time="$2"
    local expected_type="$3"

    ffmpeg -ss "$time" -i "$file" -vframes 1 -s 64x64 -f image2 -loglevel error -y "check.png"
    [[ ! -f "check.png" ]] && return 1

    ffmpeg -f lavfi -i color=c=black:s=64x64:d=1 -vframes 1 -loglevel error -y "ref_black.png"
    ffmpeg -f lavfi -i color=c=white:s=64x64:d=1 -vframes 1 -loglevel error -y "ref_white.png"
    
    local actual_hash=$(md5sum "check.png" | awk '{print $1}')
    local black_hash=$(md5sum "ref_black.png" | awk '{print $1}')
    local white_hash=$(md5sum "ref_white.png" | awk '{print $1}')
    
    rm ref_black.png ref_white.png check.png

    if [[ "$expected_type" == "black" ]]; then
        [[ "$actual_hash" == "$black_hash" ]] && return 0
    elif [[ "$expected_type" == "white" ]]; then
        [[ "$actual_hash" == "$white_hash" ]] && return 0
    fi
    return 1
  }

  testValidation() {
    local output=$(fff convert)
    [[ "$output" == *"Usage:"* ]] && echo "✅ Validation OK" || return 1
  }

  testConvert() {
    local out="combined_output.gif"
    echo "📝 Checking: $out"
    fff convert combined.mp4 to gif >/dev/null 2>&1
    [[ -f "$out" ]] && echo "✅ Convert OK" || return 1
  }

  testSpaces() {
    local out="space video_output.gif"
    echo "📝 Checking: $out"
    fff convert "space video.mp4" to gif >/dev/null 2>&1
    [[ -f "$out" ]] && echo "✅ Spaces OK" || return 1
  }

  testVisualIntegrity() {
    echo "🧪 Verifying content logic via PNG hashes..."
    local out="combined_trimmed.mp4"
    
    # Test Black Half
    echo "📝 Checking black segment: $out"
    fff trim combined.mp4 from 00:00 to 00:01 >/dev/null 2>&1
    if ! check_color "$out" "0.5" "black"; then
       echo "❌ Failed: Trimmed file 1 is not black"
       return 1
    fi

    # Test White Half
    echo "📝 Checking white segment: $out"
    fff trim combined.mp4 from 00:01 to 00:02 >/dev/null 2>&1
    if ! check_color "$out" "0.5" "white"; then
       echo "❌ Failed: Trimmed file 2 is not white"
       return 1
    fi

    echo "✅ Visual Integrity Verified"
    return 0
  }

  setupTestAssets || return 1
  local test_functions=(
    "testValidation" "testConvert" 
    "testSpaces" "testVisualIntegrity" 
    "testFFFCleanup" "testFFFMergeLoop"
  local ignored_tests=()
  
  bashTestRunner test_functions ignored_tests
  local runner_exit_code=$?
  
  cleanupArtifacts
  return $runner_exit_code
}
