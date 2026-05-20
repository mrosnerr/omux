## ADDED Requirements

### Requirement: Pane tab enters inline rename mode on double-click
The system SHALL enter inline rename mode for a pane tab when the user double-clicks the tab's label area in the pane tab strip.

#### Scenario: Double-click activates inline editor
- **WHEN** the user double-clicks a pane tab label in the tab strip
- **THEN** the tab label is replaced by an inline text field pre-populated with the current display name (alias if set, otherwise the process title)

#### Scenario: Single click does not activate rename
- **WHEN** the user single-clicks a pane tab label
- **THEN** the tab is selected and no inline editor appears

### Requirement: Inline rename commits on Return or focus loss
The system SHALL commit the entered alias when the user presses Return or moves focus away from the inline editor.

#### Scenario: Commit on Return
- **WHEN** the inline editor is active and the user presses Return
- **THEN** the entered text is committed as the pane alias and the editor is dismissed

#### Scenario: Commit on focus loss
- **WHEN** the inline editor is active and focus moves to any other UI element
- **THEN** the entered text is committed as the pane alias and the editor is dismissed

#### Scenario: Empty commit clears alias
- **WHEN** the inline editor is committed with an empty string
- **THEN** the pane alias is cleared and the tab resumes displaying its process-driven title

### Requirement: Inline rename cancels on Escape
The system SHALL discard the in-progress edit when the user presses Escape.

#### Scenario: Escape discards edit
- **WHEN** the inline editor is active and the user presses Escape
- **THEN** the editor is dismissed without modifying the pane alias

### Requirement: Inline editor uses system text input pipeline
The system SHALL delegate all text entry in the inline editor to AppKit's standard text input pipeline to ensure correct behavior with IME, dead keys, and compose sequences.

#### Scenario: Dead key sequence resolves inside editor
- **WHEN** the user types a dead key sequence (e.g., dead acute + e → é) in the inline editor
- **THEN** the composed character appears in the editor field without triggering any pane action mid-sequence

#### Scenario: IME composition completes before commit
- **WHEN** the user is composing a character via IME and presses Return
- **THEN** the IME composition is finalized by AppKit before the commit is processed
