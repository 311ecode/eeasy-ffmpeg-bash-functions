# fff — Easy ffmpeg function

A simple, intuitive command-line tool that wraps ffmpeg functionality using natural language syntax. Instead of complex ffmpeg flags, use plain English commands like "convert this file to gif" or "compress this video to 10mb".

## 📋 Quick Start

To enable the `fff` function in your terminal, simply source the project loader:

```bash
# Add this to your .bashrc or .zshrc
source /path/to/fff/loader

```

## 🚀 Usage Guide

### Convert

**`fff convert <file> to <format>`**

* **Example:** `fff convert video.mp4 to gif`
* **Example:** `fff convert movie.mov to mp4`
* **Example:** `fff convert song.wav to mp3`

### Compress

**`fff compress <file> to <size>mb`**

* **Example:** `fff compress large_video.mp4 to 10mb`
* **Example:** `fff compress recording.mov to 5mb`

### Trim

**`fff trim <file> from <start> to <end>`**

* **Example:** `fff trim clip.mp4 from 00:01:30 to 00:02:00`
* **Example:** `fff trim audio.mp3 from 00:10 to 00:45`

---

## 🧪 Testing

This project uses [bashTestRunner](https://github.com/311ecode/bashTestRunner) for quality assurance.

To run the test suite:

1. Source the **bashTestRunner** loader.
2. Source the **fff** loader.
3. Execute the test command.

```bash
source path/to/bashTestRunner/loader
source path/to/fff/loader
testFFF

```

## 🔧 Requirements

* **ffmpeg**: Required for all media operations.
* **Bash**: Version 4.0 or higher.

## 📝 Notes

* All operations are **non-destructive** (original files remain untouched).
* Output files are named with suffixes: `_output`, `_compressed`, or `_trimmed`.
