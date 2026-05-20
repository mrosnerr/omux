## Context

Pane tabs in the `PaneHeaderView` tab strip display a title sourced entirely from `pane.title`, which is kept up-to-date by OSC title sequences from the running process. `PaneTabButton` currently has no rename gesture. The workspace sidebar already supports double-click rename (stored as `workspace.customName`) — this change brings the same pattern to pane tabs, using a separate `userAlias` field on `Pane` to avoid interfering with the dynamic title pipeline.

## Goals / Non-Goals

**Goals:**
- Double-click on a pane tab label enters an inline rename editor in place.
- Committed name stored as `pane.userAlias`; takes display precedence over `pane.title`.
- When alias is set, programmatic title updates (`titleChanged`, OSC, agent RPC) continue writing `pane.title` but do not change the tab display.
- Empty commit clears the alias; dynamic title display resumes.
- Alias persisted with workspace state across restarts.
- IPC exposes `pane.alias.get`, `pane.alias.set`, `pane.alias.clear` as explicit named operations.

**Non-Goals:**
- Renaming workspace-level sidebar items (already implemented via `workspace.customName`).
- Changing how `pane.title` is stored or updated internally.
- Syncing aliases across machines.
- Replacing the dynamic title system.

## Decisions

### 1. Alias on `Pane`, not on `Tab` or `PaneStack`

**Decision:** `userAlias: String?` is a field on `Pane`. Display resolution: `pane.userAlias ?? pane.title`.

**Rationale:** Each pane tab button maps 1:1 to a `Pane`. The OSC title sequence is per-pane. Putting the alias on `Pane` keeps the scope tight and the blocking logic local to the existing `titleChanged` handler.

**Alternative considered:** Alias on `Tab`. Rejected — a `Tab` wraps a `PaneStack` which may hold multiple panes; aliasing the Tab would apply one name to all panes, which doesn't match the UX of "rename this specific tab button".

### 2. Alias blocks display update, not data write

**Decision:** `titleChanged` continues to write `pane.title`. When `pane.userAlias` is non-nil, the display-promotion step (where `pane.title` is set to the sanitized display title for the tab label) is skipped. The raw reported title is still stored in `pane.terminalState.reportedTitle`.

**Rationale:** Tooling that reads `pane.title` via RPC or hooks should still get the current process title. Only the visual tab label is pinned to the alias.

### 3. Double-click detection using `mouseDown(with:)` `clickCount`

**Decision:** Override `mouseDown(with:)` in `PaneTabButton`. If `event.clickCount == 2` and no drag handlers are involved, activate the inline editor. Single-click continues to call `onPress` for tab selection.

**Rationale:** Consistent with the existing `SidebarItemButton` double-click approach already in the codebase. Avoids `NSClickGestureRecognizer` priority conflicts with single-click selection.

**Keyboard considerations:** The inline `NSTextField` uses AppKit's standard input context. No custom key routing. Commit on Return (`\r`) via `NSTextFieldDelegate.control(_:textView:doCommandBy:)`. Cancel on Escape via `cancelOperation`. IME composition and dead keys are handled entirely by AppKit — the same pattern used in `SidebarItemButton.beginInlineRename()`.

### 4. Empty commit = clear alias

**Decision:** Submitting an empty string from the inline editor calls `clearPaneAlias` rather than no-op. This gives users a gesture to restore dynamic titles without needing a separate menu item.

### 5. `PaneTabButton` gains `onRename` and `onClearAlias` callbacks

**Decision:** Mirror the `SidebarItemButton` pattern exactly: `var onRename: ((String) -> Void)?` and `var onClearAlias: (() -> Void)?`. `PaneHeaderView` wires these to `WorkspaceController` methods.

### 6. Undo via `NSUndoManager`

**Decision:** The rename and clear-alias actions register undo entries on the window's `NSUndoManager`, restoring the previous alias value.

### 7. IPC: explicit alias operations only

**Decision:** `pane.alias.set` is the only path to set `pane.userAlias` programmatically. Generic title-update operations do not set it as a side effect.

## Risks / Trade-offs

- **PaneTabButton layout during edit**: The inline `NSTextField` should occupy the same frame as the static `titleLabel` to avoid layout shifts. The existing `SidebarItemButton` toggles `isEditable` on the existing label field in-place — `PaneTabButton` should do the same.
- **IME Return during composition**: AppKit's `NSTextFieldDelegate.controlTextDidEndEditing` handles finalization correctly; do not intercept Return at a lower level.
- **Alias visible in sidebar**: The sidebar pane list shows `metadata.title` derived from `pane.title` (via `SidebarMetadataResolver`). The alias does not currently flow there. This is acceptable for v1 — the alias is scoped to the tab strip display.

## Open Questions

- Should the alias be shown in tooltips on the pane tab (replacing the raw `pane.title` tooltip)? Lean toward: show alias as the tooltip when set, raw title as a secondary tooltip — defer to a follow-up.
