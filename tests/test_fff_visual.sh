#!/usr/bin/env bash

testFFFVisual() {
  setupAssets() {
    ffmpeg -f lavfi -i testsrc=duration=1:size=1280x720:rate=30 -loglevel error -y input_720p.mp4
  }

  cleanup() {
    rm -f input_720p.mp4 *_output.* *_rotated.* *_flipped.* *_cropped.*
  }

  testResizePreset() {
    fff resize input_720p.mp4 to 480p >/dev/null 2>&1
    local height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 input_720p_output.mp4)
    [[ "$height" == "480" ]] && echo "✅ Resize Preset OK" || return 1
  }

  testResizeCustom() {
    fff resize input_720p.mp4 to 640x360 >/dev/null 2>&1
    local dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 input_720p_output.mp4)
    [[ "$dim" == "640x360" ]] && echo "✅ Resize Custom OK" || return 1
  }

  testRotate() {
    fff rotate input_720p.mp4 by 90 >/dev/null 2>&1
    local dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 input_720p_rotated.mp4)
    [[ "$dim" == "720x1280" ]] && echo "✅ Rotate OK" || return 1
  }

  testFlip() {
    fff flip input_720p.mp4 horizontal >/dev/null 2>&1
    [[ -f "input_720p_flipped.mp4" ]] && echo "✅ Flip OK" || return 1
  }

  testCrop() {
    fff crop input_720p.mp4 to 100x100 >/dev/null 2>&1
    local dim=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 input_720p_cropped.mp4)
    [[ "$dim" == "100x100" ]] && echo "✅ Crop OK" || return 1
  }

  setupAssets
  local visual_tests=("testResizePreset" "testResizeCustom" "testRotate" "testFlip" "testCrop")
  local ignored=()
  
  # Pass both required positional arguments
  bashTestRunner visual_tests ignored
  local code=$?
  cleanup
  return $code
}
