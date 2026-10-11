# SoundBlaster Homebrew Tap

Homebrew tap for SoundBlaster command-line tools.

## Install

```bash
brew tap SoundBlaster/tap
brew install fsd-ios
fsd-ios doctor
```

To install Tokenkeeper:

```bash
brew install SoundBlaster/tap/tokenkeeper
tokenkeeper --version
```

To install the Screener MCP server:

```bash
brew install screener-mcp
```

The formula builds Screener from source and requires macOS 15.2+ with Xcode 16.3
or later. To add it to Codex, point the MCP client at the installed executable:

```bash
codex mcp add screener -- "$(brew --prefix screener-mcp)/bin/screener-mcp" \
  --traces-dir "$HOME/ScreenerTraces"
```

To install Dreams (Matrix digital rain that follows Codex and Claude Code agents):

```bash
brew install --cask SoundBlaster/tap/dreams
```

The cask installs the notarized `Dreams.app` from the [Dreams release](https://github.com/SoundBlaster/Dreams/releases).
Connect it to your agents from its window (Agent hooks) or run
`/Applications/Dreams.app/Contents/MacOS/Dreams --install-hooks`.

To upgrade:

```bash
brew update
brew upgrade fsd-ios
brew upgrade tokenkeeper
brew upgrade screener-mcp
```

To uninstall:

```bash
brew uninstall fsd-ios
brew uninstall tokenkeeper
brew uninstall screener-mcp
brew untap SoundBlaster/tap
```

## Casks

| Cask | Description |
|---|---|
| `dreams` | Matrix digital rain that follows Codex and Claude Code agents |

## Formulae

| Formula | Description |
|---|---|
| `fsd-ios` | Feature-Sliced Design toolkit for SwiftUI and SwiftData iOS projects |
| `tokenkeeper` | Read-only metadata auditor for AI-agent credentials and configuration |
| `screener-mcp` | MCP server for inspecting local iOS and macOS UI traces |

`fsd-ios` currently installs the published `v0.4.0` release artifact from
[`SoundBlaster/FSD`](https://github.com/SoundBlaster/FSD).

`tokenkeeper` installs the published `v0.2.3` release artifact from
[`SoundBlaster/tokenkeeper`](https://github.com/SoundBlaster/tokenkeeper).

## Maintenance

Run local checks before updating a formula:

```bash
make style
make smoke
```

`make smoke` creates a temporary local tap, installs every formula, and runs
each formula's `brew test` so package-specific checks run in CI.

Cask updates change `version` and `sha256` (from `make checksum` in the Dreams repository); `make cask-audit` checks the result.

Formula updates should pin a released tarball URL and SHA-256 checksum.
