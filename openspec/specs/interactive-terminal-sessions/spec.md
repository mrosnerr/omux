# interactive-terminal-sessions Specification

## Purpose
TBD - created by archiving change interactive-terminal. Update Purpose after archive.

## Requirements

### Requirement: Each pane SHALL own a persistent interactive shell session
The system SHALL back each terminal pane with a persistent interactive shell session that remains alive across multiple commands until the pane is explicitly closed or torn down.

#### Scenario: Focused pane keeps one shell alive
- **WHEN** a workspace opens a pane and the user runs multiple commands in that pane
- **THEN** the commands execute in the same ongoing shell session rather than separate one-off subprocesses

### Requirement: Interactive sessions SHALL stream output back into the pane
The system SHALL stream shell output from the live session into the owning pane as it is produced, instead of waiting for a command-complete response.

#### Scenario: Long-running command updates the pane continuously
- **WHEN** a command prints output over time in a live pane session
- **THEN** the pane updates as output arrives from the running session

### Requirement: Session teardown SHALL clean up interactive resources
The system SHALL release PTY, process, observer, and session resources when a pane-backed interactive session is torn down.

#### Scenario: Closing a pane stops its live session
- **WHEN** a pane-backed interactive session is destroyed
- **THEN** the system tears down the associated interactive shell resources without leaving the session running invisibly

### Requirement: Run-command submits commands in live terminal sessions
Interactive terminal sessions SHALL execute commands sent through run-command by inserting the command text into the targeted live session and submitting it with the terminal backend's correct Return/Enter mechanism.

#### Scenario: Runtime-backed pane executes run command
- **WHEN** a client sends run-command to a Ghostty-backed live terminal session
- **THEN** the command is submitted for shell execution without requiring the user to press Return manually

#### Scenario: Fallback pane executes run command
- **WHEN** a client sends run-command to a fallback live terminal session
- **THEN** the command is submitted for shell execution without requiring the user to press Return manually

### Requirement: Raw send-text does not imply command submission
Interactive terminal sessions SHALL support raw text insertion separately from command execution.

#### Scenario: Send text leaves prompt editable
- **WHEN** a client sends raw text to a live terminal session
- **THEN** the text appears in the target terminal input stream without an implicit Return/Enter submission

#### Scenario: Send text preserves keyboard input semantics
- **WHEN** raw text is sent by automation
- **THEN** OpenMUX does not reinterpret that text as physical keyboard input, Option/Alt combinations, dead keys, compose sequences, or IME composition
