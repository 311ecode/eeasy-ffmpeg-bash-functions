#!/usr/bin/env bash

testFFFVisual() {
  setupAssets() {
    # Generate a 100x100 black box with a 20x20 white square in the TOP-LEFT (0,0)
    # This allows us to track where the 'content' moves after rotation.
    ffmpeg -f lavfi -i "color=c=black:s=100x100:d=1" \
           -vf "drawbox=x=0:y=0:w=20:h=20:color=white:t=fill" \
           -loglevel error -y corner_ref.mp4
  }

  cleanup() {
    rm -f corner_ref.mp4 *_output.* *_rotated.* *_flipped.* *_cropped.* check_pixel.txt
  }

  # Helper to check if a specific pixel is White
  # Usage: is_white <file> <x> <y>
  is_white() {
    local file="$1"
    local x="$2"
    local y="$3"
    # Extract 1x1 pixel at x,y and output its brightness (Y channel)
    local val=$(ffmpeg -i "$file" -vf "format=gray,crop=1:1:$x:$y" -f rawvideo -vframes 1 - 2>/dev/null | od -An -t u1 | tr -d ' ')
    # If brightness > 200, it's white
    [[ "$val" -gt 200 ]]
  }

  testRotateVisual() {
    echo "🧪 Testing 90° CW Rotation Visually..."
    fff rotate corner_ref.mp4 by 90 >/dev/null 2>&1
    
    # After 90 deg CW, the white square at (0,0) moves to TOP-RIGHT (80,0)
    if is_white "corner_ref_rotated.mp4" 80 5; then
        echo "✅ Rotate 90° Content OK"
    else
        echo "❌ Rotate 90° Failed: Content in wrong position"
        return 1
    fi
  }

  testFlipVisual() {
    echo "🧪 Testing Horizontal Flip Visually..."
    fff flip corner_ref.mp4 horizontal >/dev/null 2>&1
    
    # After H-Flip, TOP-LEFT moves to TOP-RIGHT
    if is_white "corner_ref_flipped.mp4" 80 5; then
        echo "✅ Flip Horizontal Content OK"
    else
        echo "❌ Flip Horizontal Failed"
        return 1
    fi
  }

  setupAssets
  local visual_tests=("testRotateVisual" "testFlipVisual")
  local ignored=()
  
  bashTestRunner visual_tests ignored
  local code=$?
  cleanup
  return $code
}
