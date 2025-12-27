#!/usr/bin/env bash

testFFFMergeLoop() {
  setupAssets() {
    # 1s Black video
    ffmpeg -f lavfi -i "color=c=black:s=100x100:d=1" -loglevel error -y black.mp4
    # 1s White video
    ffmpeg -f lavfi -i "color=c=white:s=100x100:d=1" -loglevel error -y white.mp4
  }

  cleanup() {
    rm -f black.mp4 white.mp4 *_merged.* *_looped.*
  }

  is_white() {
    local val=$(ffmpeg -i "$1" -vf "format=gray,crop=1:1:50:50" -f rawvideo -vframes 1 -ss "$2" - 2>/dev/null | od -An -t u1 | tr -d ' ')
    [[ "$val" -gt 200 ]]
  }

  testMergeVisual() {
    echo "🧪 Testing Merge Visually..."
    fff merge black.mp4 and white.mp4 >/dev/null 2>&1
    
    # At 0.5s should be black, at 1.5s should be white
    if ! is_white "black_merged.mp4" 0.5 && is_white "black_merged.mp4" 1.5; then
        echo "✅ Merge Visual Integrity OK"
    else
        echo "❌ Merge Visual Integrity Failed"
        return 1
    fi
  }

  testLoopDuration() {
    echo "🧪 Testing Loop Duration..."
    fff loop black.mp4 3 times >/dev/null 2>&1
    
    # 1s video looped 3 times should be 3s
    local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 black_looped.mp4)
    # Use printf to handle float comparison
    if (( $(echo "$duration >= 3.0" | bc -l) )); then
        echo "✅ Loop Duration OK"
    else
        echo "❌ Loop Duration Failed: Got $duration"
        return 1
    fi
  }

  setupAssets
  local merge_tests=("testMergeVisual" "testLoopDuration")
  local ignored=()
  bashTestRunner merge_tests ignored
  local code=$?
  cleanup
  return $code
}
