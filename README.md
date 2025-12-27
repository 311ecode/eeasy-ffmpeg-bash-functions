# fff

**Stop Googling ffmpeg commands.**

```bash
fff convert video.mp4 to gif

```

That's it. No flags. No manuals. Just plain English.

**fff** is a pure Bash port of [ezff](https://github.com/josharsh/ezff). It functions as a lightweight wrapper for `ffmpeg` that lives in your shell.

## Installation

No `npm`, no dependencies (other than `ffmpeg`). Just source it.

1. **Clone the repo:**
```bash
git clone [https://github.com/yourusername/ezfff.git](https://github.com/yourusername/ezfff.git)
cd ezfff

```


2. **Source it in your shell:**
```bash
source fff.sh

```


3. **(Optional) Add to your `.bashrc` or `.zshrc`:**
```bash
echo 'source /path/to/ezfff/fff.sh' >> ~/.bashrc

```



## Usage

Once sourced, the `fff` command is available globally.

### Convert

```bash
fff convert video.mp4 to gif
fff convert recording.wav to mp3

```

### Compress

Target a specific file size.

```bash
fff compress video.mp4 to 10mb
fff compress large_file.mov to 50mb

```

### Trim

Cut video without re-encoding (where possible).

```bash
fff trim video.mp4 from 00:30 to 01:00

```

### Help

```bash
fff help

```

## How It Works

The architecture is modular. `fff` acts as a router that dispatches commands to specific function files loaded into the namespace.

```text
User Input: "fff convert ..."
     ↓
fff() [Router in fff.sh]
     ↓ checks fff_functions/
Calls fff_convert() [in fff_functions/fff_convert.sh]
     ↓
Executes ffmpeg command

```

## Testing

We use [bashTestRunner](https://github.com/311ecode/bashTestRunner) for our test suite. It allows us to run isolated, robust tests on the shell functions.

To run the tests, use the provided helper script which automatically handles the test runner dependency:

```bash
./scripts/run_tests.sh

```

If you want to explore the test runner framework itself, visit the **[bashTestRunner repository](https://github.com/311ecode/bashTestRunner)**.

## Requirements

* **Bash** 4.0+
* **ffmpeg** installed and in PATH

## License

MIT
