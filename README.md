# SoundBlaster Homebrew Tap

Homebrew tap for SoundBlaster command-line tools.

## Install

```bash
brew tap SoundBlaster/tap
brew install fsd-ios
fsd-ios doctor
```

To upgrade:

```bash
brew update
brew upgrade fsd-ios
```

To uninstall:

```bash
brew uninstall fsd-ios
brew untap SoundBlaster/tap
```

## Formulae

| Formula | Description |
|---|---|
| `fsd-ios` | Feature-Sliced Design toolkit for SwiftUI and SwiftData iOS projects |

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
