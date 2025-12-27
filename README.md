# fff

**Stop Googling ffmpeg commands.**

```bash
fff convert video.mp4 to gif

```

**fff** is a pure Bash port of [ezff](https://github.com/josharsh/ezff).

## Installation

1. **Clone:**
```bash
git clone [https://github.com/yourusername/ezfff.git](https://github.com/yourusername/ezfff.git)

```


2. **Load:**
Source the `loader` file. This statically loads all functions into your shell.
```bash
source ./ezfff/loader

```



## Usage

```bash
fff convert video.mp4 to gif
fff compress video.mp4 to 10mb
fff help

```

## How It Works

1. **Loader**: The `loader` script sources all function files (`fff_functions/*.sh`) into your current shell environment.
2. **Router**: The `fff` command acts as a simple dispatcher. It checks if the requested function (e.g., `fff_convert`) is already loaded in memory and runs it.

## Testing

To run tests, source the test loader and run the suite:

```bash
# 1. Load the main app
source ./ezfff/loader

# 2. Load the tests
source ./ezfff/loader-tests

# 3. Run the suite (requires bashTestRunner)
./scripts/run_tests.sh

```

## License

MIT
