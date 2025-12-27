# fff — Plain English Bash ffmpeg wrapper

A simple, intuitive command-line tool that wraps ffmpeg functionality using natural language syntax. Instead of complex ffmpeg flags, use plain English commands like "convert this file to gif" or "compress this video to 10mb".

## 📋 Parameters & Usage

### Available Commands

#### `fff convert <file> to <format>`
Converts media files between different formats.

**Parameters:**
- `<file>`: **Required** - Input media file (video or audio)
- `to`: **Required** - Literal word "to"
- `<format>`: **Required** - Target format (gif, mp3, wav, aac, flac, ogg, mp4, mov, etc.)

**Examples:**
```bash
fff convert video.mp4 to gif
fff convert audio.m4a to mp3
fff convert movie.mov to mp4
```

#### `fff compress <file> to <size>mb`
Compresses video files to approximately target file size.

**Parameters:**
- `<file>`: **Required** - Input video file
- `to`: **Required** - Literal word "to"
- `<size>mb`: **Required** - Target size in megabytes (e.g., "10mb", "5mb")

**Examples:**
```bash
fff compress large.mov to 10mb
fff compress presentation.mp4 to 5mb
```

#### `fff trim <file> from <start> to <end>`
Trims video/audio files to specific time segments.

**Parameters:**
- `<file>`: **Required** - Input media file
- `from`: **Required** - Literal word "from"
- `<start>`: **Required** - Start timestamp (format: HH:MM:SS or MM:SS)
- `to`: **Required** - Literal word "to"
- `<end>`: **Required** - End timestamp (format: HH:MM:SS or MM:SS)

**Examples:**
```bash
fff trim video.mp4 from 00:30 to 01:00
fff trim audio.mp3 from 01:15 to 03:45
```

#### `fff help`
Displays this help information.

## 🚀 Quick Start Examples

```bash
# Convert a video to animated GIF
fff convert demo.mp4 to gif

# Compress a large video file
fff compress presentation.mov to 20mb

# Extract a clip from a video
fff trim tutorial.mp4 from 02:30 to 05:15

# Extract audio from video
fff convert movie.mp4 to mp3

# Get help
fff help
```

## 🔧 Technical Details

### Output Files
- Convert: Creates `<filename>_output.<format>`
- Compress: Creates `<filename>_compressed.<extension>`
- Trim: Creates `<filename>_trimmed.<extension>`

### Special Format Handling

**GIF Conversion:**
- Uses high-quality palette generation
- 15 FPS, scaled to 480px width (maintaining aspect ratio)
- Lanczos scaling for better quality
- Infinite loop

**Audio Extraction:**
Supported formats: mp3, wav, aac, flac, ogg
- Extracts audio track only
- Preserves original audio quality

**Video Compression:**
Uses CRF (Constant Rate Factor) based on target size:
- ≤5 MB: CRF 32 (higher compression)
- ≤10 MB: CRF 28
- ≤20 MB: CRF 26
- Default: CRF 23

**Trimming:**
- Uses stream copy for fast, lossless trimming
- No re-encoding, maintains original quality

## 📁 Project Structure

```
fff/
├── fff.sh                    # Main entry point
├── fff_functions/           # Command implementations
│   ├── fff_compress.sh      # Compression logic
│   ├── fff_convert.sh       # Format conversion
│   ├── fff_help.sh          # Help documentation
│   └── fff_trim.sh          # Trimming functionality
└── tests/
    └── test_fff.sh          # Test suite
```

## 🧪 Testing

Run the test suite to verify functionality:
```bash
# From project root
./tests/test_fff.sh
```

Tests include:
- Format conversion validation
- Compression execution
- Trimming functionality
- Input validation and error handling

## ⚠️ Requirements

- **ffmpeg**: Must be installed and available in PATH
- **Bash**: Version 4.0 or higher
- **Permissions**: Execute permission for script files

## 🐛 Error Handling

The tool provides clear error messages for:
- Missing required parameters
- Invalid file paths
- Unsupported formats
- Incorrect command syntax

## 📝 Notes

- All operations are non-destructive - original files are preserved
- Output files are created in the current working directory
- For batch operations, consider wrapping in shell loops
- The tool uses ffmpeg's default codecs and settings for simplicity

## 🤝 Contributing

To add new functionality:
1. Create a new function file in `fff_functions/`
2. Name it `fff_<command>.sh`
3. Implement the function following existing patterns
4. Update the help documentation in `fff_help.sh`
5. Add tests in `tests/test_fff.sh`
