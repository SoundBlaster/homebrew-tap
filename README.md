# SoundBlaster Homebrew Tap

Homebrew tap for SoundBlaster command-line tools.

## Install

```bash
brew tap SoundBlaster/tap
brew install fsd-ios
fsd-ios doctor
```

To install the Screener MCP server:

```bash
brew install screener-mcp
```

The formula builds Screener from source and requires macOS 13+ with Xcode 16.3
or later. To add it to Codex, point the MCP client at the installed executable:

```bash
codex mcp add screener -- "$(brew --prefix screener-mcp)/bin/screener-mcp" \
  --traces-dir "$HOME/ScreenerTraces"
```

To upgrade:

```bash
brew update
brew upgrade fsd-ios
brew upgrade screener-mcp
```

To uninstall:

```bash
brew uninstall fsd-ios
brew uninstall screener-mcp
brew untap SoundBlaster/tap
```

## Formulae

| Formula | Description |
|---|---|
| `fsd-ios` | Feature-Sliced Design toolkit for SwiftUI and SwiftData iOS projects |
| `screener-mcp` | MCP server for inspecting local iOS and macOS UI traces |

`fsd-ios` currently installs the published `v0.4.0` release artifact from
[`SoundBlaster/FSD`](https://github.com/SoundBlaster/FSD).

## Maintenance

Run local checks before updating a formula:

```bash
make style
make smoke
```

`make smoke` creates a temporary local tap, installs the formula through
Homebrew, runs `brew test`, verifies the installed wrapper, and checks
`fsd-ios doctor --json`.

Formula updates should pin a released tarball URL and SHA-256 checksum.
