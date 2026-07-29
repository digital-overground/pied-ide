# Pied IDE

Pied IDE is Digital Overground's public fork of [Zed](https://github.com/zed-industries/zed). It tracks upstream Zed while publishing a focused Pied build for macOS on Apple Silicon.

## Install

Install the latest stable release:

```sh
curl -fsSL https://raw.githubusercontent.com/digital-overground/pied-ide/main/script/install.sh | sh
```

Or install through Homebrew:

```sh
brew tap digital-overground/tap
brew install --cask pied
```

Install a specific version:

```sh
curl -fsSL https://raw.githubusercontent.com/digital-overground/pied-ide/main/script/install.sh | PIED_VERSION=1.0.0 sh
```

The installer downloads `Pied-aarch64.dmg`, installs `Pied.app` in `/Applications`, and makes the `pied` command available through `~/.local/bin`.

## Releases And Updates

Pied uses its own version stream. The app version lives in [crates/zed/Cargo.toml](./crates/zed/Cargo.toml), and stable tags must match it as `pied-vMAJOR.MINOR.PATCH`.

Use `Pied IDE Release` in GitHub Actions to publish a release from a branch or commit. The release tag must match the app version. It runs fast formatting, spelling, script, and workflow checks, then builds one Apple Silicon DMG. Cargo artifacts are cached so repeat builds avoid recompiling unchanged dependencies.

Every published build is a normal GitHub Release. The installer and in-app updater both use GitHub's latest release.

## Upstream

This repository remains a GitHub fork of [zed-industries/zed](https://github.com/zed-industries/zed), so upstream changes can be fetched and merged over time. Pied-specific changes are intentionally concentrated in the release, installer, updater, and macOS bundle paths.

## Developing

The local macOS bundle command is:

```sh
./script/bundle-mac aarch64-apple-darwin
```

It creates `target/aarch64-apple-darwin/release/Pied-aarch64.dmg`. The first build compiles the editor; later local builds reuse Cargo's normal incremental artifacts.

Pull requests and pushes to `main` run `Pied CI`, the same fast checks used by releases. The inherited full Zed workspace suite is deliberately not part of the normal Pied development loop.

## License

Pied is a GPL-3.0-or-later fork of Zed. The source license and generated third-party dependency notices are retained in the build; no separate commercial license is required to build or use Pied.
