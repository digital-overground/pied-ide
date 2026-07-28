# Pied IDE

Pied IDE is Digital Overground's public fork of [Zed](https://github.com/zed-industries/zed). It tracks upstream Zed while publishing Pied builds and update metadata from [digital-overground/pied-ide](https://github.com/digital-overground/pied-ide).

This fork keeps Zed's fast editor foundation and adds the release/update path needed for the Pied + Pi ACP setup. Some internal names, commands, and release asset filenames still use `zed` so the fork can continue merging upstream changes with less friction.

## Install

Install the latest macOS or Linux release:

```sh
curl -fsSL https://raw.githubusercontent.com/digital-overground/pied-ide/main/script/install.sh | sh
```

Install a pinned version:

```sh
curl -fsSL https://raw.githubusercontent.com/digital-overground/pied-ide/main/script/install.sh | ZED_VERSION=1.0.0 sh
```

Windows users can download the installer from [GitHub Releases](https://github.com/digital-overground/pied-ide/releases). Current release asset names are:

- macOS Apple Silicon: `Zed-aarch64.dmg`
- macOS Intel: `Zed-x86_64.dmg`
- Linux ARM64: `zed-linux-aarch64.tar.gz`
- Linux x86_64: `zed-linux-x86_64.tar.gz`
- Windows x86_64: `Zed-x86_64.exe`

## Releases and Updates

Pied IDE uses its own semantic version stream. The app version lives in [crates/zed/Cargo.toml](./crates/zed/Cargo.toml), and release tags must match it as `pied-vMAJOR.MINOR.PATCH`.

Publishing a tag such as `pied-v1.0.0` runs the `Pied IDE Release` workflow, which builds macOS DMGs, Linux tarballs, the Windows installer, and remote-server assets, then uploads them to GitHub Releases.

The in-app updater checks [digital-overground/pied-ide releases](https://github.com/digital-overground/pied-ide/releases). Set `PIED_IDE_RELEASE_REPO=owner/repo` only when testing against another release repository.

## Upstream

This repository remains a GitHub fork of [zed-industries/zed](https://github.com/zed-industries/zed), so upstream Zed changes can be fetched and merged over time.

The practical rule for this fork is to keep Pied-specific changes small, visible, and easy to reapply during upstream merges.

## Developing

Most upstream Zed development documentation still applies:

- [Building Zed for macOS](./docs/src/development/macos.md)
- [Building Zed for Linux](./docs/src/development/linux.md)
- [Building Zed for Windows](./docs/src/development/windows.md)

Useful local checks:

```sh
cargo fmt --all -- --check
cargo check -p release_channel -p zed
```

## License

Pied IDE inherits Zed's licensing. Zed source code is licensed primarily under GPL-3.0-or-later, with Apache-2.0 components where marked.

License information for third-party dependencies must be correctly provided for CI to pass. The upstream project uses [`cargo-about`](https://github.com/EmbarkStudios/cargo-about) to help comply with open source license requirements.
