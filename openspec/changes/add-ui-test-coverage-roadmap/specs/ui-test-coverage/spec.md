## ADDED Requirements

### Requirement: UI tests SHALL prove terminal interaction remains usable
The UI test suite SHALL include at least one end-to-end terminal interaction smoke test that launches the packaged UI-test app, focuses a terminal pane, submits deterministic terminal input, and verifies user-visible terminal output or session state without inspecting libghostty internals.

#### Scenario: Focused terminal accepts deterministic input
- **WHEN** the UI-test app launches with a visible terminal pane
- **THEN** a UI test can focus the pane, submit a deterministic command or input string, and observe the expected user-visible result in the pane or associated OpenMUX session state

#### Scenario: Terminal smoke test preserves bridge boundary
- **WHEN** a UI test verifies terminal interaction
- **THEN** it asserts OpenMUX-visible behavior through the app accessibility tree, CLI/control-plane state, or bridge-owned public surfaces rather than importing terminal-engine-specific types

### Requirement: UI tests SHALL cover pane focus across splits and pane tabs
The UI test suite SHALL verify that pane splitting, pane-tab switching, pane-tab closing, and pane focus navigation leave keyboard input targeted at the intended terminal pane.

#### Scenario: Split pane focus receives input
- **WHEN** a UI test creates a split and focuses a specific pane
- **THEN** deterministic terminal input is delivered to that focused pane rather than another visible pane

#### Scenario: Pane tab switch receives input
- **WHEN** a UI test creates multiple pane-local tabs and switches the active tab
- **THEN** deterministic terminal input is delivered to the selected pane tab's session

### Requirement: UI tests SHALL assert visible label updates for rename workflows
The UI test suite SHALL verify that successful workspace and pane-tab rename interactions update visible shell labels, not only that rename sheets or inline editors dismiss.

#### Scenario: Workspace rename updates sidebar label
- **WHEN** a UI test renames a workspace through the native shell
- **THEN** the workspace sidebar item exposes the new label through the accessibility tree

#### Scenario: Pane tab rename updates tab label
- **WHEN** a UI test renames a pane-local tab through the context-menu or inline editor path
- **THEN** the pane-tab control exposes the new label through the accessibility tree

### Requirement: UI tests SHALL cover command palette keyboard workflows
The UI test suite SHALL verify command palette behavior through keyboard-driven interactions as well as pointer clicks.

#### Scenario: Command palette invokes selected command with Return
- **WHEN** the command palette is open in command mode with an enabled selected result
- **THEN** pressing Return invokes the selected result and closes the palette

#### Scenario: Command palette supports navigation and dismissal
- **WHEN** the command palette is open with multiple results
- **THEN** keyboard navigation changes the selected result and Escape dismisses the palette without sending palette query text to the focused terminal

#### Scenario: Command palette sub-palette can be exited
- **WHEN** the command palette is inside a sub-palette such as theme selection
- **THEN** the documented keyboard dismissal or back behavior returns to the expected state without crashing or leaving stale focus

### Requirement: UI tests SHALL cover pane find behavior
The UI test suite SHALL verify the native pane find workflow for opening, searching, navigating matches, and closing.

#### Scenario: Find bar opens and accepts query
- **WHEN** a UI test invokes Find in Pane
- **THEN** the find bar appears, accepts a query, and exposes match status or navigation controls through accessible UI

#### Scenario: Find bar closes and restores terminal focus
- **WHEN** a UI test dismisses the find bar
- **THEN** terminal focus returns to the previously focused pane and subsequent terminal input is not captured by the find field

### Requirement: UI tests SHALL cover layout persistence after relaunch
The UI test suite SHALL include a relaunch workflow that verifies user-visible workspace layout state survives app termination and restart in the UI-test sandbox.

#### Scenario: Workspace layout restores after relaunch
- **WHEN** a UI test creates a layout with multiple visible structural elements and relaunches the UI-test app
- **THEN** the restored app exposes the expected workspace, pane, and pane-tab structure

#### Scenario: Sidebar visibility restores after relaunch
- **WHEN** a UI test changes workspace-column visibility and relaunches the UI-test app
- **THEN** the workspace column visibility matches the last persisted OpenMUX UI state

### Requirement: UI tests SHALL cover extension pane smoke paths
The UI test suite SHALL verify that extension-pane and floating-pane shell surfaces can be created, focused, and closed through OpenMUX-owned UI or control-plane workflows without taking terminal focus or bridge ownership.

#### Scenario: Extension pane appears in shell layout
- **WHEN** a UI test creates an extension pane through a supported test-safe plugin or control-plane path
- **THEN** the shell exposes the extension pane through stable accessibility identifiers or labels

#### Scenario: Floating pane modal can close cleanly
- **WHEN** a UI test opens a pane or extension pane in a floating modal
- **THEN** the modal can be focused and closed while leaving the main workspace usable

#### Scenario: Pane tab can pop out to modal
- **WHEN** a UI test opens a pane-tab context menu and chooses the pop-out action
- **THEN** the pane tab appears in a floating pane modal that can be focused and closed while leaving the main workspace usable

#### Scenario: Plugin-owned pane action can dispatch
- **WHEN** a UI test invokes a supported plugin-owned action for an extension pane
- **THEN** OpenMUX dispatches the action through the plugin-owned pane action path and leaves the shell responsive

### Requirement: UI tests SHALL cover bundled plugin workflows
The UI test suite SHALL include smoke coverage for bundled plugin experiences whose UI is part of the shipped application surface, including Markdown Preview and Agent Sessions.

#### Scenario: Markdown Preview opens rendered content
- **WHEN** a UI test opens a local Markdown file through the bundled Markdown Preview workflow
- **THEN** OpenMUX creates the configured preview surface and exposes rendered Markdown content through stable user-visible UI

#### Scenario: Markdown Preview updates existing preview
- **WHEN** a UI test changes the watched Markdown file during an active preview
- **THEN** the preview updates the existing pane or modal instead of creating duplicate stale preview surfaces

#### Scenario: Agent Sessions opens searchable session UI
- **WHEN** a UI test opens the bundled Agent Sessions workflow
- **THEN** OpenMUX exposes the Agent Sessions UI with searchable/filterable session controls or an explicit empty state

#### Scenario: Agent Sessions can close without disturbing terminal focus
- **WHEN** a UI test closes the Agent Sessions UI
- **THEN** the main workspace remains usable and terminal focus returns to the expected pane

### Requirement: UI tests SHALL account for keyboard correctness risk
The UI test suite SHALL include keyboard-path coverage for shell shortcuts and terminal-owned input where AppKit event routing can regress, and SHALL avoid masking Option/Alt, right-Option, dead-key, compose, or IME-sensitive behavior behind menu-only tests when keyboard behavior is the subject under test.

#### Scenario: Shell shortcut path is tested directly
- **WHEN** a workflow depends on an OpenMUX keybinding or native menu key equivalent
- **THEN** at least one UI test for that workflow uses synthesized keyboard input rather than only selecting the native menu item

#### Scenario: Terminal-owned modified input is not claimed by shell chrome
- **WHEN** a UI test covers modified terminal input for a supported layout-sensitive case
- **THEN** OpenMUX preserves terminal-owned input semantics and does not route the input as an unrelated shell action
