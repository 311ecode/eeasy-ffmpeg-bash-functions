#!/usr/bin/env bash
# @file test_fff.sh
# @description Test suite for the fff (Plain English ffmpeg wrapper)
# @dependencies ffmpeg, bashTestRunner

# 📍 Source the fff entry point (adjust path if needed based on where you run tests)
# We assume this script runs from the project root

testFFF() {
  export LC_NUMERIC=C 🔢

  # 🛠️ HELPER: Generate Test Assets
  setupTestAssets() {
    echo "🎬 Generating 1s Test Assets (Black & White videos)..."
    
    # Generate 1s Black Video with Silent Audio
    if [ ! -f "black.mp4" ]; then
      ffmpeg -f lavfi -i color=c=black:s=640x480:d=1 \
             -f lavfi -i anullsrc=r=44100:cl=stereo \
             -c:v libx264 -c:a aac -shortest -t 1 \
             -loglevel error -y "black.mp4"
    fi

    # Generate 1s White Video with Silent Audio
    if [ ! -f "white.mp4" ]; then
      ffmpeg -f lavfi -i color=c=white:s=640x480:d=1 \
             -f lavfi -i anullsrc=r=44100:cl=stereo \
             -c:v libx264 -c:a aac -shortest -t 1 \
             -loglevel error -y "white.mp4"
    fi
  }

  # 🧹 HELPER: Cleanup
  cleanupArtifacts() {
    echo "🧹 Cleaning up test artifacts..."
    rm -f black.mp4 white.mp4 *_output.* *_compressed.* *_trimmed.*
  }

  # 🧪 TEST: Convert
  testConvert() {
    echo "🧪 Testing: fff convert"
    
    # Action: Convert black.mp4 to GIF
    fff convert black.mp4 to gif >/dev/null 2>&1
    local result=$?
    
    if [[ $result -eq 0 ]] && [[ -f "black_output.gif" ]]; then
      echo "✅ SUCCESS: Converted to GIF"
      return 0
    else
      echo "❌ ERROR: Conversion failed or output file missing"
      return 1
    fi
  }

  # 🧪 TEST: Compress
  testCompress() {
    echo "🧪 Testing: fff compress"
    
    # Action: Compress white.mp4 to 1mb
    fff compress white.mp4 to 1mb >/dev/null 2>&1
    local result=$?
    
    if [[ $result -eq 0 ]] && [[ -f "white_compressed.mp4" ]]; then
      echo "✅ SUCCESS: Compression executed"
      return 0
    else
      echo "❌ ERROR: Compression failed"
      return 1
    fi
  }

  # 🧪 TEST: Trim
  testTrim() {
    echo "🧪 Testing: fff trim"
    
    # Action: Trim black.mp4
    fff trim black.mp4 from 00:00 to 00:01 >/dev/null 2>&1
    local result=$?
    
    if [[ $result -eq 0 ]] && [[ -f "black_trimmed.mp4" ]]; then
      echo "✅ SUCCESS: Trim executed"
      return 0
    else
      echo "❌ ERROR: Trim failed"
      return 1
    fi
  }

  # 🧪 TEST: Help/Validation
  testValidation() {
    echo "🧪 Testing: Input Validation"
    
    # Capture output of missing args
    local output=$(fff convert)
    
    if [[ "$output" == *"Usage:"* ]]; then
      echo "✅ SUCCESS: Detected missing arguments"
      return 0
    else
      echo "❌ ERROR: Failed to catch missing arguments"
      return 1
    fi
  }

  # 🚀 EXECUTION FLOW
  
  # 1. Generate Assets
  setupTestAssets

  # 2. Register Tests
  local test_functions=(
    "testValidation"
    "testConvert"
    "testCompress"
    "testTrim"
  )

  local ignored_tests=()

  # 3. Run Runner
  bashTestRunner test_functions ignored_tests
  local runner_exit_code=$?

  # 4. Cleanup
  cleanupArtifacts

  return $runner_exit_code
}

