# fff — Plain English Bash ffmpeg wrapper

A simple, intuitive command-line tool that wraps ffmpeg functionality using natural language syntax. Instead of complex ffmpeg flags, use plain English commands like "convert this file to gif" or "compress this video to 10mb".

## 📋 Installation & Usage

To use `fff` in your terminal, simply source the loader file in your `.bashrc` or current session:

```bash
source /path/to/fff/loader

```

### Available Commands

#### `fff convert <file> to <format>`

Converts media files between different formats.

**Parameters:**

* `<file>`: **Required** - Input media file (video or audio)
* `to`: **Required** - Literal word "to"
* `<format>`: **Required** - Target format (gif, mp3, wav, aac, flac, ogg, mp4, mov, etc.)

**Examples:**

```bash
fff convert video.mp4 to gif
fff convert audio.m4a to mp3

```

#### `fff compress <file> to <size>mb`

Compresses video files to approximately target file size.

**Parameters:**

* `<file>`: **Required** - Input video file
* `to`: **Required** - Literal word "to"
* `<size>mb`: **Required** - Target size in megabytes (e.g., "10mb")

#### `fff trim <file> from <start> to <end>`

Trims video/audio files to specific time segments.

**Parameters:**

* `<file>`: **Required** - Input media file
* `from`: **Required** - Literal word "from"
* `<start>`: **Required** - Start timestamp (HH:MM:SS or MM:SS)
* `to`: **Required** - Literal word "to"
* `<end>`: **Required** - End timestamp (HH:MM:SS or MM:SS)

---

## 🧪 Testing

The test suite requires the [bashTestRunner](https://github.com/311ecode/bashTestRunner).

To run the tests:

1. Source the **bashTestRunner** loader.
2. Source the **fff** loader.
3. Run the test function:

```bash
source /path/to/bashTestRunner/loader
source /path/to/fff/loader
testFFF

```

## 🔧 Technical Details

* **Output Files**: Created in the working directory with suffixes like `_output`, `_compressed`, or `_trimmed`.
* **GIF Conversion**: Uses high-quality palette generation and Lanczos scaling.
* **Audio Extraction**: Supports mp3, wav, aac, flac, and ogg.
* **Video Compression**: Dynamically adjusts CRF based on target size (5MB, 10MB, 20MB thresholds).

## ⚠️ Requirements

* **ffmpeg**: Must be installed and available in PATH.
* **Bash**: Version 4.0 or higher.
