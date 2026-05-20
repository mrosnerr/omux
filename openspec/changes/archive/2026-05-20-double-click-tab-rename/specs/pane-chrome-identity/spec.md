## ADDED Requirements

### Requirement: Pane carries an optional user alias for display
The system SHALL support an optional `userAlias: String?` field on each pane. When set, the pane tab strip SHALL display the alias in place of the process-driven title.

#### Scenario: Alias takes display precedence over process title
- **WHEN** a pane has a user alias `api` and a process title `node server.js`
- **THEN** the pane tab displays `api`

#### Scenario: No alias falls through to process title
- **WHEN** a pane has no user alias and a process title `vim README.md`
- **THEN** the pane tab displays `vim README.md`

### Requirement: User alias blocks programmatic display updates
When a user alias is set, the system SHALL NOT update the pane tab's displayed name in response to any programmatic title write (OSC sequences, agent RPC, shell integrations, or other automated sources).

#### Scenario: OSC title sequence is ignored when alias is set
- **WHEN** a pane has a user alias set and the terminal emits an OSC title-change sequence
- **THEN** the pane tab continues to display the user alias without change

#### Scenario: Programmatic title is stored but not displayed
- **WHEN** a pane has a user alias set and a programmatic title update arrives
- **THEN** the internal title field is updated and remains readable via the control plane, but the tab display does not change

### Requirement: Clearing the user alias restores dynamic title display
The system SHALL remove the user alias and resume dynamic title display when the alias is explicitly cleared.

#### Scenario: Clear alias restores process title display
- **WHEN** the user clears the alias from a pane tab
- **THEN** the tab reverts to displaying the current process-driven title

#### Scenario: Programmatic title updates resume after alias is cleared
- **WHEN** the user clears the alias and the terminal emits an OSC title-change sequence
- **THEN** the pane tab display updates normally

### Requirement: Pane user alias is persisted across app restarts
The system SHALL persist `pane.userAlias` alongside other pane state and restore it on launch.

#### Scenario: Alias survives restart
- **WHEN** a pane has a user alias set and the application is restarted
- **THEN** the alias is restored and the pane tab continues to display the alias after restart

### Requirement: Control plane exposes explicit pane alias operations
The system SHALL expose `pane.alias.get`, `pane.alias.set`, and `pane.alias.clear` as discrete IPC operations. Setting an alias via `pane.alias.set` SHALL be the only programmatic path to set a pane user alias; ordinary title-update operations SHALL NOT set the alias as a side effect.

#### Scenario: Alias readable via IPC
- **WHEN** a client calls `pane.alias.get` for a pane with alias `api`
- **THEN** the response returns `"api"`

#### Scenario: Alias settable via explicit IPC method
- **WHEN** a client calls `pane.alias.set` with value `worker`
- **THEN** the pane alias is set to `worker` and the tab displays `worker`

#### Scenario: Title update does not set alias
- **WHEN** a client sends a generic title-update message for a pane
- **THEN** the pane `userAlias` field remains unchanged

#### Scenario: Alias clearable via IPC
- **WHEN** a client calls `pane.alias.clear` for a pane with an active alias
- **THEN** the alias is removed and the tab resumes displaying the process-driven title
