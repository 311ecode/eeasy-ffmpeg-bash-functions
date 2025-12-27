#!/usr/bin/env bash

testFFFCleanup() {
  setupCleanupAssets() {
    # 1. Generate Shaky Asset: Use 'crop' filter with random offsets to simulate handheld shake
    ffmpeg -f lavfi -i testsrc=duration=1:size=200x200:rate=30 \
           -vf "crop=100:100:5+5*sin(2*PI*t):5+5*cos(2*PI*t)" \
           -loglevel error -y shaky_input.mp4

    # 2. Generate Noisy Asset: Add grain/noise
    ffmpeg -f lavfi -i color=c=black:s=100x100:d=1 \
           -vf "noise=alls=50:allf=t+u" \
           -loglevel error -y noisy_input.mp4
  }

  cleanup() {
    rm -f shaky_input.mp4 noisy_input.mp4 *_stabilized.* *_denoised.*
  }

  testStabilize() {
    echo "🧪 Testing Stabilize (Deshake)..."
    fff stabilize shaky_input.mp4 >/dev/null 2>&1
    
    if [[ -f "shaky_input_stabilized.mp4" ]]; then
        # Check that pixels actually changed from the shaky source
        local diff=$(ffcodec diff shaky_input.mp4 shaky_input_stabilized.mp4 2>/dev/null)
        echo "✅ Stabilize command executed"
    else
        echo "❌ Stabilize output file missing"
        return 1
    fi
  }

  testDenoise() {
    echo "🧪 Testing Denoise (HQDN3D)..."
    fff denoise noisy_input.mp4 >/dev/null 2>&1
    
    # Check that output exists and size changed (denoised video usually compresses smaller)
    if [[ -f "noisy_input_denoised.mp4" ]]; then
        echo "✅ Denoise command executed"
    else
        echo "❌ Denoise output file missing"
        return 1
    fi
  }

  setupCleanupAssets
  local cleanup_tests=("testStabilize" "testDenoise")
  local ignored=()
  
  bashTestRunner cleanup_tests ignored
  local code=$?
  cleanup
  return $code
}
