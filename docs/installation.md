# Installation

## Prerequisites

- `bash >= 4.3`
- GNU coreutils

If you are on macOS, you need to install the latest `bash` and `coreutils`:

```sh
# Install prerequisite packages
brew install bash coreutils
```

See the full list of supported operating systems in [Support](./support.md)

## Install

##### 1. Clone `bpm`

```sh
git clone https://github.com/bpmpm/bpm "${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source"
```

By default, this installs bpm to `$HOME/.local/share/bpm/source`

##### 2. Add initialization script to shell profile

This enables bpm to automatically setup your `PATH`, set completion variables, source completion files, and other things


For `bash`, `zsh`, `sh`

```sh
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin:$PATH"
eval "$(bpm init bash)" # replace 'bash' with your shell
```

For `fish`

```fish
set -gx PATH "${XDG_DATA_HOME:-$HOME/.local/share}/bpm/source/pkg/bin" $PATH
status --is-interactive; and . (bpm init fish | psub)
```

And now you're done! Move on to [Getting Started](./getting-started.md) to learn the basics