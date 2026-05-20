## Why

The current XCUIAutomation suite provides useful shell-chrome smoke coverage, but it does not yet prove that OpenMUX remains a working terminal-first workspace after common UI operations. As pane, workspace, command palette, persistence, and plugin surfaces grow, we need an explicit UI-test coverage contract so regressions in the native shell and focused terminal interaction are caught before release.

## What Changes

- Define a UI-test coverage roadmap for terminal-first workflows that `make ui-test` should cover.
- Require tests for focused terminal interaction, pane focus across splits/tabs, workspace and pane label updates, command palette keyboard behavior, pane find, layout persistence, and extension-pane smoke paths.
- Require UI tests to exercise native keyboard/menu/command-palette entry points where the behavior depends on AppKit focus and accessibility.
- Keep UI tests behind the existing `make ui-test` flow and Xcode/XCUITest stack; no new background service, browser automation layer, or terminal-engine-specific test API is introduced.
- Keep terminal-engine details behind the existing bridge boundary by asserting user-visible OpenMUX behavior rather than importing or inspecting libghostty internals.

## Capabilities

### New Capabilities
- `ui-test-coverage`: Defines the expected XCUIAutomation coverage for critical native shell and terminal-first workflows.

### Modified Capabilities
- None.

## Impact

- Affected files: `Tests/OmuxUITests/**`, `Tests/OmuxUITests/A11yID+UITests.swift`, `Sources/OmuxAppShell/A11yID.swift`, `docs/development.md`, and potentially focused AppKit accessibility identifiers needed for stable UI queries.
- Affected workflows: `make ui-test`, `.github/workflows/ui-tests.yml`, and local contributor setup documented in developer docs.
- API impact: no public CLI, JSON-RPC, hook, plugin, or terminal bridge API changes are expected.
- Keyboard/input impact: tests that synthesize keyboard input must preserve the distinction between shell shortcuts and terminal-owned input, including Option/Alt, right-Option, dead-key, compose, and IME-sensitive behavior where practical.
