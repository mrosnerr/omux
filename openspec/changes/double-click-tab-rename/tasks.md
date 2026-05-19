## 1. Pane Model — userAlias Field

- [x] 1.1 Add `userAlias: String?` to the `Pane` struct alongside `title`
- [x] 1.2 Add `userAlias` to `Pane.CodingKeys` and update `init(from:)` and `encode(to:)` to include it
- [x] 1.3 Update `Pane` initializers to accept `userAlias` with a default of `nil`
- [x] 1.4 Add a unit test: pane with alias survives encode → decode round-trip
- [x] 1.5 Add a unit test: pane without alias decodes correctly (backward-compatible with saved state that has no `userAlias` key)

## 2. Display Resolution — Pane Tab Label

- [x] 2.1 Update `PaneTabButton` to resolve its display label as `pane.userAlias ?? pane.title` (pass alias through init or add an `alias` parameter)
- [x] 2.2 Guard the `titleChanged` handler in `WorkspaceController`: when `pane.userAlias` is non-nil, still write the incoming title to `pane.title` (and `pane.terminalState.reportedTitle`) but skip promoting it to the tab display (i.e., skip setting `pane.title` to the display title when an alias is set, or keep a separate display-title resolution path)
- [x] 2.3 Add a unit test: setting an alias on a pane causes `displayTitle` to return the alias, not the process title
- [x] 2.4 Add a unit test: clearing the alias causes `displayTitle` to return the process title again

## 3. Inline Rename — PaneTabButton

- [x] 3.1 Add `var onRename: ((String) -> Void)?` and `var onClearAlias: (() -> Void)?` to `PaneTabButton`
- [x] 3.2 Update `mouseDown(with:)` in `PaneTabButton`: detect `clickCount == 2` on the tab label area and activate the inline editor; single-click continues to call `onPress`
- [x] 3.3 Add `beginInlineRename()`: toggle the existing `titleLabel` (`NSTextField`) to editable, pre-populate with current display name, make first responder, select all
- [x] 3.4 Implement `NSTextFieldDelegate` on `PaneTabButton`: `control(_:textView:doCommandBy:)` commits on `insertNewline`, cancels on `cancelOperation`
- [x] 3.5 Implement `controlTextDidEndEditing`: if non-empty → call `onRename`; if empty → call `onClearAlias`; restore non-editable state
- [x] 3.6 Confirm `NSTextField` uses system input context with no custom key routing (dead keys and IME handled by AppKit)

## 4. WorkspaceController — Alias Operations

- [x] 4.1 Add `setPaneAlias(_ paneID: PaneID, to alias: String) throws -> Workspace?` to `WorkspaceController`; trims whitespace; non-empty sets `pane.userAlias`; empty calls `clearPaneAlias`; emits `pane-alias-set` hook; calls `onChange`
- [x] 4.2 Add `clearPaneAlias(_ paneID: PaneID) throws -> Workspace?` to `WorkspaceController`; sets `pane.userAlias = nil`; emits `pane-alias-cleared` hook; calls `onChange`

## 5. PaneHeaderView Wiring — Rename with Undo

- [x] 5.1 Add `onRenamePaneTab` and `onClearPaneTabAlias` closure parameters to `PaneHeaderView.init`
- [x] 5.2 In `PaneHeaderView`, wire each `PaneTabButton.onRename` to `onRenamePaneTab(pane.id, newName)` and `onClearAlias` to `onClearPaneTabAlias(pane.id)`
- [x] 5.3 In `WorkspaceShellViewController.update(workspace:)`, provide closures that call `controller.setPaneAlias` / `controller.clearPaneAlias` and register undo entries on `view.window?.undoManager` (restoring previous alias, action name "Rename Tab" / "Clear Tab Name")

## 6. IPC / Control Plane — Pane Alias Operations

- [x] 6.1 Add `getPaneAlias = "pane.alias.get"`, `setPaneAlias = "pane.alias.set"`, `clearPaneAlias = "pane.alias.clear"` to `ControlMethod`
- [x] 6.2 Implement `pane.alias.get` in `handleOnMain`: resolve pane by `paneID` param (or focused pane); return `userAlias` or null
- [x] 6.3 Implement `pane.alias.set` in `handleOnMain`: require `paneID` and `alias` params; call `controller.setPaneAlias`; return updated workspace RPC object
- [x] 6.4 Implement `pane.alias.clear` in `handleOnMain`: require `paneID`; call `controller.clearPaneAlias`; return updated workspace RPC object
- [x] 6.5 Confirm no existing title-update RPC path sets `pane.userAlias` as a side effect
- [x] 6.6 Add `userAlias` and `hasUserAlias` to the pane's RPC object shape (where pane data is serialized for `workspace.list` / `pane.status` responses)
- [x] 6.7 Add integration test: `pane.alias.set` round-trips over socket; `pane.alias.get` returns it; `pane.alias.clear` removes it
