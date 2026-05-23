## 1. Workspace Controller Boundary Extraction

- [ ] 1.1 Define internal interfaces for workspace state/index management and move pure state logic behind them.
- [ ] 1.2 Extract hook/control-plane publication helpers into a dedicated publication seam and route existing event emission through that seam.
- [ ] 1.3 Add/expand tests proving behavioral parity for create/focus/split/close/restore controller flows, including stable hook/event payload compatibility.
- [ ] 1.4 Document the publication seam as the required attachment point for future open-by-design transition wiring.

## 2. Incremental Slice Migration

- [ ] 2.1 Move one mutation/query slice at a time from `WorkspaceController` into extracted modules with no API behavior change.
- [ ] 2.2 Keep terminal bridge boundary intact by enforcing OpenMUX-native types in extracted module contracts.
- [ ] 2.3 Add invariant and regression tests for indexed lookup correctness and event payload compatibility.
- [ ] 2.4 Verify extracted publication paths do not add new inline hook/control-plane wiring outside the dedicated seam for migrated controller slices.

## 3. CLI Picker Unification

- [ ] 3.1 Extract shared terminal picker engine (raw mode lifecycle, rendering, key parsing, filtering).
- [ ] 3.2 Rewire theme and plugin picker implementations to the shared engine while preserving command UX semantics.
- [ ] 3.3 Add tests for shared key handling and terminal cleanup on success/cancel/error exits.

## 4. Documentation and Validation

- [ ] 4.1 Update developer documentation describing new controller module boundaries and extension points.
- [ ] 4.2 Update planning/documentation notes to reference the publication seam as the prerequisite for open-by-design parity follow-up work.
- [ ] 4.3 Run existing AppShell/CLI/ControlPlane tests to verify no keyboard/input or control-plane regressions.
