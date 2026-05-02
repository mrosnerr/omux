# Changelog

OpenMUX release notes are committed here before tagging a release. Use `Scripts/check-changes-since-release.sh` to inspect changes since the latest `v*` tag, then use `Scripts/prepare-release.sh <version>` with a reviewed changelog body to prepare the next release.

## 0.2.0

### Added

- Added a committed release-prep workflow with `VERSION`, `CHANGELOG.md`, change inspection, release preparation scripts, and the `create-release-notes` agent skill.
- Added runtime-hosted terminal support for standard macOS edit commands, clipboard callbacks, terminal selection queries, and shell-quoted dropped-file path paste.

### Changed

- Changed terminal input routing so OpenMUX only intercepts documented app shortcuts while forwarding unclaimed Command, Option, Control, modified Backspace, arrow-key, dead-key, compose, IME, and right-Option international input paths to Ghostty with key and modifier facts preserved.
- Changed release packaging to read the product version from `VERSION` by default while still allowing `RELEASE_VERSION` overrides.

### Fixed

- Fixed runtime-hosted pane pointer handling for focus-on-click ordering, stale mouse-button release reconciliation, hover exit behavior, scroll events, and pressure events.
- Fixed preedit and committed-text handling so marked text updates, cancelled composition, and generated text are routed without duplicate terminal input.

## 0.1.0

### Added

- Added the initial native macOS OpenMUX app shell with workspaces, top-level tabs, split panes, pane-local tab stacks, and persistent interactive shell sessions.
- Added bridge-backed terminal panes through the vendored Ghostty runtime, kept behind the OpenMUX terminal bridge boundary.
- Added the local `omux` CLI and JSON-RPC control plane for opening workspaces, listing state, creating tabs and splits, targeting live sessions, sending text, running commands, raising notifications, and streaming events.
- Added external hook support and a mixed local event stream for terminal runtime events and shared workspace/session actions.
- Added OpenMUX-owned configuration and theme foundations with `~/.omux/config.toml`, user theme overrides, generated Ghostty config artifacts, built-in themes, and theme CLI commands.
- Added early keyboard-correctness support for native AppKit terminal input, including ISO layout, Option/Alt, dead-key, compose, and IME-sensitive flows.
- Added unsigned macOS release packaging for both `OpenMUX.app` and the bundled `omux` CLI, including checksums and a GitHub Release workflow.
- Added an app-bundled CLI installer so users can install `omux` from the app menu or from `/Applications/OpenMUX.app/Contents/MacOS/omux install-cli`.

### Known limitations

- Release artifacts are ad-hoc signed but not yet Developer ID signed, notarized, distributed as a DMG, or published through Homebrew.
