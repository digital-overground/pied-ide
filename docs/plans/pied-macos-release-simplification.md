# Pied macOS release simplification

## Goal

Make it fast and dependable to turn a small Pied change into an installable
Apple Silicon macOS build. Keep the upstream relationship, but remove Zed
automation that Pied does not operate.

## Decisions

- Supported release target: macOS on Apple Silicon (`aarch64-apple-darwin`).
- Keep three workflows only: pull-request checks, alpha releases, and stable
  releases.
- Alpha and stable releases both produce `Pied-aarch64.dmg` plus the macOS
  remote-server asset needed by the app.
- Keep the inherited GPL-3.0-or-later source license and generated third-party
  dependency notices. They are legal attribution for the fork's dependencies,
  not a commercial license that Kyle needs to acquire.
- Allow a bundle to generate the notice file when a dependency has incomplete
  metadata, while surfacing that condition as a warning rather than blocking an
  alpha build.
- Use Pied branding for the macOS app bundle, Finder volume, bundle identifier,
  URL scheme, and macOS document metadata.

## Implementation

1. Remove inherited Zed-only GitHub Actions workflows, retaining only
   `ci.yml`, `pied_alpha_release.yml`, and `pied_release.yml`.
2. Reduce `ci.yml` to fast formatting, spelling, shell-script, and workflow
   validation. It remains the PR and `main` gate; full-workspace tests are not
   part of the rapid iteration path.
3. Simplify alpha and stable release workflows to one Apple Silicon build. The
   alpha workflow stays manual and prerelease-only; the stable workflow runs on
   `pied-v*` tags and publishes the GitHub latest release used by the installer
   and updater. Cache Cargo build artifacts so repeat alpha builds reuse
   unchanged compilation work.
4. Update the macOS bundle path so it emits `Pied.app` and
   `Pied-aarch64.dmg` directly, uses a Pied Finder volume, and gracefully
   generates third-party notices without treating metadata warnings as a hard
   release failure.
5. Make `script/install.sh` explicitly reject unsupported platforms instead of
   offering Linux or Windows downloads that this fork no longer publishes.
6. Refresh the README to describe the single supported platform, alpha install
   command, stable install command, and the deliberately small CI/release
   surface.

## Validation

- Run formatting and workflow linting locally where available.
- Open a PR and verify the fast `Pied CI` gate.
- Dispatch an Apple Silicon alpha release and verify its GitHub release assets:
  `Pied-aarch64.dmg` and `zed-remote-server-macos-aarch64.gz`.
- Download and inspect the DMG to confirm it contains `Pied.app` and has no
  remaining Zed-facing release labels.

## Deferred

- Windows, Linux, Intel macOS, code-signing/notarization, upstream's full test
  suite, Zed cloud/collaboration deployment, issue triage bots, extension
  publishing, and documentation hosting. They can be reintroduced one at a
  time if Pied begins to need them.
