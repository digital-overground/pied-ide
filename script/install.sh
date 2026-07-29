#!/usr/bin/env sh
set -eu

# Downloads a Pied IDE macOS Apple Silicon release from GitHub and installs it.

main() {
    platform="$(uname -s)"
    arch="$(uname -m)"
    repo="${PIED_IDE_RELEASE_REPO:-digital-overground/pied-ide}"
    PIED_VERSION="${PIED_VERSION:-${ZED_VERSION:-latest}}"

    if [ "$platform" != "Darwin" ] || [ "$arch" != "arm64" ]; then
        echo "Pied IDE currently supports macOS on Apple Silicon only."
        exit 1
    fi

    if [ -n "${TMPDIR:-}" ] && [ -d "${TMPDIR}" ]; then
        temp="$(mktemp -d "$TMPDIR/pied-XXXXXX")"
    else
        temp="$(mktemp -d "/tmp/pied-XXXXXX")"
    fi

    if command -v curl >/dev/null 2>&1; then
        curl() {
            command curl -fL "$@"
        }
    elif command -v wget >/dev/null 2>&1; then
        curl() {
            wget -O- "$@"
        }
    else
        echo "Could not find 'curl' or 'wget' in your path"
        exit 1
    fi

    macos

    if [ "$(command -v pied)" = "$HOME/.local/bin/pied" ]; then
        echo "Pied IDE has been installed. Run with 'pied'"
    else
        echo "To run Pied IDE from your terminal, add ~/.local/bin to your PATH"

        case "$SHELL" in
            *zsh)
                echo "   echo 'export PATH=\$HOME/.local/bin:\$PATH' >> ~/.zshrc"
                echo "   source ~/.zshrc"
                ;;
            *fish)
                echo "   fish_add_path -U $HOME/.local/bin"
                ;;
            *)
                echo "   echo 'export PATH=\$HOME/.local/bin:\$PATH' >> ~/.bashrc"
                echo "   source ~/.bashrc"
                ;;
        esac

        echo "To run Pied IDE now, '~/.local/bin/pied'"
    fi
}

release_download_base() {
    version="$1"

    if [ "$version" = "latest" ]; then
        echo "https://github.com/$repo/releases/latest/download"
        return
    fi

    case "$version" in
        pied-v*) tag="$version" ;;
        v*) tag="pied-$version" ;;
        *) tag="pied-v$version" ;;
    esac

    echo "https://github.com/$repo/releases/download/$tag"
}

macos() {
    echo "Downloading Pied IDE version: $PIED_VERSION"
    curl "$(release_download_base "$PIED_VERSION")/Pied-aarch64.dmg" > "$temp/Pied-aarch64.dmg"
    mkdir -p "$temp/mount"
    hdiutil attach -quiet "$temp/Pied-aarch64.dmg" -mountpoint "$temp/mount"
    app="$temp/mount/Pied.app"

    if [ ! -d "$app" ]; then
        echo "The release DMG does not contain Pied.app"
        hdiutil detach -quiet "$temp/mount"
        exit 1
    fi

    echo "Installing Pied.app"
    if [ -d "/Applications/Pied.app" ]; then
        echo "Removing existing Pied.app"
        rm -rf "/Applications/Pied.app"
    fi
    ditto "$app" "/Applications/Pied.app"
    hdiutil detach -quiet "$temp/mount"

    mkdir -p "$HOME/.local/bin"
    ln -sf "/Applications/Pied.app/Contents/MacOS/cli" "$HOME/.local/bin/pied"
}

main "$@"
