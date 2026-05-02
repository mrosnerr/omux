# omux-control-plane Specification

## Purpose
TBD - created by archiving change macos-foundation. Update Purpose after archive.
## Requirements
### Requirement: The CLI controls the app through a local RPC contract
The system SHALL expose a local control plane between the OpenMUX desktop app and the `omux` CLI using JSON-RPC over a Unix domain socket for both capability requests and local event subscriptions.

#### Scenario: CLI operations use the public control boundary
- **WHEN** the `omux` CLI requests app-level behavior
- **THEN** it communicates through the local JSON-RPC control contract rather than private in-process coupling

#### Scenario: CLI event subscribers use the public control boundary
- **WHEN** the `omux` CLI subscribes to streamed OpenMUX events
- **THEN** it receives those events through the same local control-plane contract rather than a separate private transport

### Requirement: Control-plane operations are capability-oriented
The control plane SHALL expose app operations in terms of OpenMUX capabilities such as opening workspaces, focusing panes, sending text, raising notifications, and restoring sessions.

#### Scenario: RPC commands map to OpenMUX behavior
- **WHEN** automation targets the desktop application
- **THEN** the available operations align with OpenMUX concepts instead of low-level terminal-engine details

### Requirement: The control plane remains local-first and lightweight
The system SHALL treat the app/CLI control plane as a local desktop boundary optimized for inspectability and minimal operational overhead.

#### Scenario: Local automation avoids unnecessary service complexity
- **WHEN** the control plane is used on a developer workstation
- **THEN** it does not require distributed-service infrastructure or unnecessary background processes beyond the local app service itself

### Requirement: Terminal event contracts are defined in OpenMUX-native control-plane terms
The control plane SHALL define terminal event names and payload shapes in OpenMUX-native terms for local automation and streamed event delivery surfaces. These event contracts SHALL avoid Ghostty-specific enums, tags, and payload structs.

#### Scenario: Control-plane terminal event names are product-level contracts
- **WHEN** OpenMUX defines a control-plane event for terminal cwd, command completion, progress, or renderer health
- **THEN** the event name and payload shape are expressed in OpenMUX-native terms instead of Ghostty callback identifiers

#### Scenario: Terminal events remain stable inside a broader event stream
- **WHEN** terminal runtime events are published alongside shared action events through `omux events`
- **THEN** the `terminal.*` event meanings and payload fields remain stable because they are defined independently of the transport and of non-terminal event families

### Requirement: The control plane SHALL stream OpenMUX-native action events
The control plane SHALL stream OpenMUX-native event notifications for successful shared workspace, pane, tab, session, command, and notification actions through the same local event surface used by terminal runtime events.

#### Scenario: Subscriber observes a pane split action
- **WHEN** a shared pane split action succeeds
- **THEN** the control plane publishes a `pane.split` event with OpenMUX-native identifiers and payload fields

#### Scenario: Subscriber observes a restored workspace
- **WHEN** a shared workspace restore action succeeds
- **THEN** the control plane publishes a `workspace.restored` event through the local event stream

### Requirement: Control-plane event streams do not block commands
The control plane SHALL handle long-lived event stream connections without blocking unrelated request/response commands on separate connections.

#### Scenario: Events subscriber remains connected while command completes
- **WHEN** one client is connected to the event stream
- **THEN** another client can complete a control-plane command without waiting for the stream client to disconnect

#### Scenario: Multiple event subscribers do not monopolize the server
- **WHEN** multiple clients subscribe to control-plane events
- **THEN** the server still accepts and handles new request/response clients

### Requirement: Control-plane targets are explicit and OpenMUX-native
The control plane SHALL accept terminal action targets using explicit OpenMUX-native selector fields for session, pane, tab, workspace, or focused terminal selection. A selector SHALL resolve to one live terminal session before a terminal-mutating action executes.

#### Scenario: Session selector targets exact session
- **WHEN** a request targets a terminal action by session ID
- **THEN** the action applies to that exact live session

#### Scenario: Pane selector resolves active pane session
- **WHEN** a request targets a terminal action by pane ID
- **THEN** the action applies to the active local pane-tab session in that pane

#### Scenario: Workspace selector resolves focused workspace session
- **WHEN** a request targets a terminal action by workspace ID
- **THEN** the action applies to the focused terminal session in that workspace

#### Scenario: Invalid selector fails explicitly
- **WHEN** a request target cannot be resolved to a live terminal session
- **THEN** the control plane returns a structured failure instead of silently choosing another terminal

### Requirement: Control plane exposes raw terminal text input
The control plane SHALL expose a terminal text-input operation that sends caller-provided text to a resolved terminal target without appending Return or submitting a command.

#### Scenario: Send text inserts without execution
- **WHEN** a client sends text to a terminal target through the control plane
- **THEN** OpenMUX inserts that text into the target terminal input stream without adding an implicit command submission

#### Scenario: Send text is distinct from run command
- **WHEN** a client wants command execution
- **THEN** it uses the run-command operation rather than relying on raw text input

### Requirement: Control plane exposes live topology discovery
The control plane SHALL expose machine-readable discovery for open workspaces, tabs, panes, pane stacks, and sessions, including focused IDs where available.

#### Scenario: CLI can list targetable sessions
- **WHEN** a CLI or hook script requests live terminal topology
- **THEN** the response includes enough workspace, tab, pane, and session IDs to target a later action without scraping UI text

#### Scenario: Full workspace listing includes focused terminal IDs
- **WHEN** a client requests detailed workspace state
- **THEN** each workspace entry includes focused tab, pane, pane-stack, and session IDs when those entities exist

### Requirement: Control-plane action results are chainable
The control plane SHALL return structured result objects for automation actions that include relevant created, focused, or targeted OpenMUX IDs.

#### Scenario: Split result includes created terminal identifiers
- **WHEN** a split action creates a new terminal pane/session
- **THEN** the response includes the created pane ID and session ID

#### Scenario: Run command result includes target identifiers
- **WHEN** a run-command action succeeds
- **THEN** the response includes the workspace, tab, pane, and session IDs that received the command
