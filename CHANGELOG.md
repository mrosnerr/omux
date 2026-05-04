# Changelog

OpenMUX release notes are committed here before tagging a release. Use `Scripts/check-changes-since-release.sh` to inspect changes since the latest `v*` tag, then use `Scripts/prepare-release.sh <version>` with a reviewed changelog body to prepare the next release.

## 0.4.0

### Added

- Added `workspace.default_root_path` so first launch, new app-created workspaces, and `omux open` without a path can start from a configured directory.
- Added configurable OpenMUX keybindings through the `[keys]` table, including rebinding shortcuts and mapping a chord to `"none"` when a terminal application should receive it instead.
- Added inline pane-tab controls in pane headers, including an add button and close affordances for multi-tab stacks.
- Added CLI and control-plane coverage for closing workspaces, removing panes, cycling visible panes, and cycling pane-local tabs.

### Changed

- Changed the default shortcut ladder to make workspace, pane, and pane-tab actions more consistent: workspace creation/close use `Cmd+N` / `Cmd+Shift+N`, pane tabs use `Cmd+T` / `Cmd+W`, active panes use `Cmd+Shift+W`, and modified Backspace remains terminal-owned unless explicitly rebound.
- Changed menu shortcuts to follow the active keybinding configuration after startup and `omux config reload`.
- Changed config rendering so theme changes preserve the workspace and keybinding sections.
- Documented the new workspace root, keybinding syntax, shortcut actions, and expanded CLI command set.

## 0.3.0

### Added

- Added `omux history` for reading bounded terminal history from the active workspace, a specific pane, or all panes, with text and JSON output for scripts and hooks.
- Added the `terminal.history` control-plane method with bounded line/byte limits and per-pane metadata, including workspace, tab, pane, session, working-directory, truncation, and availability details.
- Added persisted pane scrollback snapshots so restored workspaces can retain recent terminal context without replaying commands.

### Changed

- Changed workspace restoration to preserve pane working directories when OpenMUX can recover them from terminal state.
- Changed workspace persistence to keep backups of previous snapshots before overwriting or clearing stored workspace state.
- Documented terminal history usage for development workflows and hooks, including guidance that history can contain sensitive terminal output.

### Fixed

- Fixed restored pane state so recent scrollback and working-directory context survive app relaunches more reliably.

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
