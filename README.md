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

To upgrade:

```bash
brew update
brew upgrade fsd-ios tokenkeeper
```

To uninstall:

```bash
brew uninstall fsd-ios tokenkeeper
brew untap SoundBlaster/tap
```

## Formulae

| Formula | Description |
|---|---|
| `fsd-ios` | Feature-Sliced Design toolkit for SwiftUI and SwiftData iOS projects |
| `tokenkeeper` | Read-only metadata auditor for AI-agent credentials and configuration |

`fsd-ios` currently installs the published `v0.4.0` release artifact from
[`SoundBlaster/FSD`](https://github.com/SoundBlaster/FSD).

`tokenkeeper` installs the published `v0.2.2` release artifact from
[`SoundBlaster/tokenkeeper`](https://github.com/SoundBlaster/tokenkeeper).

## Maintenance

Run local checks before updating a formula:

```bash
make style
make smoke
```

`make smoke` creates a temporary local tap, installs the formula through
Homebrew, runs `brew test`, verifies the installed wrapper, and checks
the formula-specific command behavior.

Formula updates should pin a released tarball URL and SHA-256 checksum.
