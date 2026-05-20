## 1. Test Infrastructure

- [ ] 1.1 Identify the most reliable assertion path for terminal output in the UI-test app: accessibility text, public control-plane/session state, or bridge-owned public surface.
- [ ] 1.2 Add narrowly scoped accessibility identifiers for any missing OpenMUX-owned UI surfaces needed by the tests.
- [ ] 1.3 Mirror new accessibility identifiers in `Tests/OmuxUITests/A11yID+UITests.swift`.
- [ ] 1.4 Add shared UI-test helpers for focusing panes, waiting for terminal/session output, and isolating test state.

## 2. Strengthen Existing Coverage

- [ ] 2.1 Update workspace rename UI tests to assert the sidebar item exposes the new workspace label.
- [ ] 2.2 Update pane-tab rename UI tests to assert the tab control exposes the new pane-tab label.
- [ ] 2.3 Update pane-tab create/close tests to assert tab counts and active tab state rather than only app liveness.
- [ ] 2.4 Update split/remove tests to assert visible pane structure returns to the expected state.

## 3. Terminal-First Workflow Tests

- [ ] 3.1 Add a terminal interaction smoke test that focuses the launch pane, submits deterministic input, and verifies the visible or OpenMUX-owned result.
- [ ] 3.2 Add a split focus test proving input goes to the selected pane after creating and focusing a split.
- [ ] 3.3 Add a pane-tab focus test proving input goes to the selected pane-local tab after switching tabs.
- [ ] 3.4 Add keyboard shortcut coverage for at least one structural shell action currently tested only through menu selection.

## 4. Command Palette And Find Tests

- [ ] 4.1 Add command palette keyboard navigation coverage for arrow selection, Return invocation, and Escape dismissal.
- [ ] 4.2 Add command palette command invocation coverage for a safe structural command such as New Pane Tab or Split Right.
- [ ] 4.3 Add command palette sub-palette keyboard coverage for theme selection or back/dismiss behavior.
- [ ] 4.4 Add pane find UI coverage for opening the find bar, typing a query, navigating matches, and closing with terminal focus restored.

## 5. Persistence And Extension Surfaces

- [ ] 5.1 Add a relaunch UI test that verifies workspace/pane/pane-tab structure restores in the UI-test sandbox.
- [ ] 5.2 Add a relaunch UI test that verifies workspace-column visibility restores.
- [ ] 5.3 Decide whether extension-pane smoke coverage uses a bundled fixture plugin, control-plane-created synthetic pane, or existing deterministic plugin.
- [ ] 5.4 Add extension-pane smoke coverage for creating, focusing, and closing an extension pane.
- [ ] 5.5 Add floating pane modal coverage for pane-tab pop-out, focus, and close behavior.
- [ ] 5.6 Add plugin-owned pane action smoke coverage for a deterministic extension pane action path.

## 6. Bundled Plugin UI Tests

- [ ] 6.1 Add Markdown Preview UI smoke coverage for opening a local Markdown file and seeing rendered preview content.
- [ ] 6.2 Add Markdown Preview update coverage for changing the watched file and updating the existing preview surface.
- [ ] 6.3 Add an Agent Sessions fixture setup that launches the UI-test app with isolated `OMUX_HOME` and deterministic seeded Vault data.
- [ ] 6.4 Add Agent Sessions UI smoke coverage for opening the bundled session browser and asserting seeded session rows plus the search/filter UI.
- [ ] 6.5 Add Agent Sessions empty-state coverage using an isolated fixture with no visible sessions.
- [ ] 6.6 Add Agent Sessions close/focus coverage to ensure returning to the main workspace restores expected terminal focus.

## 7. Validation And Documentation

- [ ] 7.1 Run targeted UI tests while iterating, such as `make ui-test UI_TEST=PaneTests/testName`.
- [ ] 7.2 Run the full UI suite with `make ui-test`.
- [ ] 7.3 Update `docs/development.md` with the new UI-test coverage expectations and helper guidance.
- [ ] 7.4 Call out any keyboard-layout-sensitive coverage limits in docs or test comments.
