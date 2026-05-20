## Why

Pane tabs in the horizontal tab strip display a title driven entirely by the terminal process (OSC sequences, shell integrations, agents). Users have no way to assign a stable, human-readable name to a pane tab — every time the working directory or running command changes, the title changes too. Adding double-click-to-rename with an alias layer gives users a stable label while leaving the underlying dynamic title intact for tooling.

Workspace-level rename (sidebar items) is already implemented and is not affected by this change.

## What Changes

- Pane tab buttons (`PaneTabButton`) respond to a double-click gesture by entering an inline text-editing mode.
- Edited names are stored as a **user alias** on the pane, separate from the process-reported title.
- When a user alias is set, the pane tab displays the alias and ignores further programmatic title updates (OSC sequences, shell integrations, agent RPC calls, etc.) to the displayed name.
- The underlying `pane.title` continues to be updated by programmatic sources so tooling that reads it is unaffected.
- The alias can be cleared by submitting an empty string, restoring dynamic title display.
- The alias is persisted with pane state and survives app restart.

## Capabilities

### New Capabilities

- `pane-tab-inline-rename`: Double-click gesture on a pane tab enters inline rename mode; commits on Return or focus-loss, cancels on Escape; non-empty commit stores a user alias; empty commit clears it.

### Modified Capabilities

- `pane-chrome-identity`: Add requirements for a `userAlias` field on `Pane` that, when set, takes display precedence over the process title in the pane tab strip and blocks programmatic display updates.

## Impact

- **Pane model**: `Pane` gains an optional `userAlias: String?` field. `Codable` encode/decode updated. Persisted with workspace state.
- **Title-update path**: The `titleChanged` handler in `WorkspaceController` must check `pane.userAlias` — if set, it still writes the new title to `pane.title` (so the value is available to tools) but skips updating the display (i.e., skips promoting to `pane.title` for display purposes, or maintains a separate display-title resolution).
- **`PaneTabButton` display**: The label rendered in the tab strip resolves `userAlias ?? pane.title`.
- **`PaneTabButton` gesture**: Double-click detected via `mouseDown(with:)` `clickCount == 2`. Inline `NSTextField` instantiated in-place using AppKit's standard input pipeline (no custom key routing — IME, dead keys, compose sequences handled by AppKit).
- **`WorkspaceController`**: New `setPaneAlias(_:to:)` and `clearPaneAlias(_:)` methods.
- **IPC/RPC**: `pane.alias.get`, `pane.alias.set`, `pane.alias.clear` discrete RPC methods. Generic title-update RPC does not set the alias as a side effect.
- **No libghostty bridge changes**: OSC title sequences continue writing to the internal title field; the bridge boundary is unaffected.
- **No sidebar / workspace rename changes**: Workspace-level double-click rename is already implemented and remains unchanged.
