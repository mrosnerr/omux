## Context

OpenMUX already has an XCUIAutomation suite under `Tests/OmuxUITests`, run through `make ui-test`. The current suite covers app launch, basic workspace operations, pane splitting and pane-tab operations, command palette open/close and theme switching, and workspace-column toggling. Much of that coverage is smoke-oriented: it verifies that shell chrome exists or that actions do not crash, but it often does not verify the resulting terminal interaction, focused pane ownership, or visible label state.

This change defines the next UI-test coverage baseline. It does not introduce a new test framework or product feature. It uses the existing AppKit/XCUITest path because these risks are specifically about native focus, accessibility, menus, keyboard routing, and packaged UI-test app behavior.

## Goals / Non-Goals

**Goals:**
- Prioritize terminal-first UI coverage: focused terminal input, pane/session targeting, and relaunch persistence.
- Convert existing smoke-only checks into assertions of user-visible state where practical.
- Add coverage for keyboard-driven workflows, not just menu and pointer paths.
- Keep tests stable on local machines and GitHub Actions macOS runners.
- Keep `libghostty` details behind `OmuxTerminalBridge`; UI tests should assert user-visible behavior or OpenMUX-owned state.

**Non-Goals:**
- Do not add browser automation, webview testing, or a separate UI automation service.
- Do not expose libghostty test-only internals outside the terminal bridge.
- Do not make the core product depend on test-only behavior.
- Do not attempt exhaustive terminal emulator conformance testing in XCUI tests; terminal fidelity belongs mostly in lower-level bridge/runtime tests.

## Decisions

### Use XCUITest as the UI authority

Continue using `xcodebuild test` with the generated Xcode project and `Tests/OmuxUITests`.

Alternatives considered:
- Browser-style automation: rejected because OpenMUX is AppKit-first and the behavior under test is native focus/accessibility.
- Pure Swift unit tests: useful for controller behavior, but insufficient for AppKit first-responder, menu, drag/drop, and accessibility regressions.

### Assert OpenMUX-visible terminal behavior

Terminal interaction UI tests should focus a pane, submit deterministic input, and verify output or state through accessible UI, public CLI/control-plane state, or bridge-owned public surfaces. They should not import libghostty types or inspect upstream runtime internals.

Alternatives considered:
- Test-only libghostty hooks in UI tests: rejected because they weaken the terminal bridge boundary and can pass while user-visible behavior is broken.
- Screenshot-only assertions: useful as a fallback for rendering smoke, but too brittle as the primary signal.

### Add stable accessibility identifiers only where needed

When new tests need access to pane content, find UI, extension panes, or modals, add narrowly scoped `A11yID` constants and mirror them in `A11yID+UITests.swift`. Prefer identifiers on OpenMUX-owned shell chrome and controls; avoid exposing terminal-engine internals.

Alternatives considered:
- Querying by view hierarchy position alone: rejected because current tests already show that custom AppKit views need stable identifiers for reliable CI behavior.
- Large broad identifier pass across every view: deferred to avoid churn unrelated to the requested coverage.

### Keep the suite layered by risk

Use UI tests for workflows where native shell behavior matters: launch, focus, menus, keyboard shortcuts, drag/drop, persistence, command palette, pane find, and extension panes. Keep controller and parser edge cases in unit tests.

Alternatives considered:
- Moving all workflow assertions to UI tests: rejected because it would make the suite slow and flaky.
- Leaving current smoke tests unchanged: rejected because smoke checks do not catch the most important terminal-first regressions.

### Seed bundled plugin data instead of mocking UI state

Bundled plugin UI tests should use deterministic local fixtures. For Agent Sessions, prefer launching the UI-test app with an isolated `OMUX_HOME` and a seeded `agent-sessions.sqlite` database or import bundle, then drive the real Agent Sessions UI through menus, command palette, or control-plane UI actions. This avoids needing real Codex/Gemini/Copilot processes while still testing the real Vault store, search path, sidebar/palette UI, and focus restoration.

Alternatives considered:
- Running real agent CLIs during UI tests: rejected because it is slow, environment-dependent, and not what the UI workflow needs to prove.
- Mocking Agent Sessions rows inside the view layer: rejected because it can pass while the real Vault store, filtering, and UI wiring are broken.
- Testing only the empty state: useful as one smoke path, but insufficient for search/filter/resume-row UI behavior.

## Risks / Trade-offs

- Flaky terminal output timing -> Use deterministic commands, explicit wait predicates, and bounded timeouts; avoid arbitrary sleeps.
- Headless CI hittability issues -> Continue coordinate-based event synthesis where justified, but prefer accessible controls and stable identifiers.
- Keyboard layout sensitivity -> Keep layout-sensitive assertions narrow and document exactly what each test proves; do not overgeneralize one machine layout to all locales.
- Slower UI suite -> Prioritize high-value workflows and avoid duplicating lower-level unit coverage.
- Persistence tests leaking state -> Use the existing sandboxed UI-test app bundle and isolated test state setup/teardown.
- Agent Sessions fixture drift -> Build fixtures from `VaultExportBundle`/`VaultSessionSummary` shapes or through `VaultStore.import(data:)` so UI tests stay aligned with the real data model.

## Migration Plan

1. Add the missing accessibility identifiers needed for stable assertions.
2. Strengthen existing tests that already cover rename and pane-tab workflows.
3. Add terminal interaction and focus-targeting tests before lower-priority shell chrome tests.
4. Add persistence, pane find, command palette keyboard, and extension-pane smoke tests incrementally.
5. Keep `make ui-test` and CI as the validation entrypoints.

Rollback is straightforward: individual UI tests can be disabled or narrowed without changing product APIs. Any added accessibility identifiers can remain as harmless stable metadata.

## Open Questions

- What is the most reliable OpenMUX-visible way to assert terminal output in the packaged UI-test app: accessibility text, control-plane session history, or a bridge-owned testing surface?
- Should extension-pane smoke coverage use a bundled test fixture plugin, a control-plane-created synthetic pane, or an existing bundled plugin with deterministic behavior?
- How much keyboard layout coverage can GitHub Actions realistically provide, and which cases should remain lower-level input-pipeline tests instead of XCUI tests?
