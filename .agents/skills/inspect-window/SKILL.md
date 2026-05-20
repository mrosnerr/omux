---
name: inspect-window
description: Inspect a running OpenMUX window's live AppKit view hierarchy. Use when debugging event delivery issues (clicks, drags, key events), verifying view layout, or investigating unexpected view state.
---

# Inspect Window

Inspect the live AppKit view hierarchy of a running OpenMUX instance. macOS-only
— uses AppKit introspection and lldb, which are specific to the macOS
development toolchain.

## Prerequisites

- **macOS** with Xcode Command Line Tools installed.
- OpenMUX must be running (dev build via `make app` / `swift run OpenMUXApp`,
  or a packaged `.app`).
- `lldb` (ships with Xcode Command Line Tools).
- SIP must allow debugger attachment (default on dev machines; disable
  `com.apple.security.cs.debugger` restrictions if needed).

## Steps

### 1. Find the process

```bash
pgrep -fl OpenMUXApp
```

Store the PID for subsequent lldb commands. If the app is not running, build
and launch it:

```bash
GHOSTTY_RESOURCES_DIR="Vendor/ghostty/zig-out/share/ghostty" swift run OpenMUXApp &
sleep 3
pgrep -f OpenMUXApp
```

### 2. Dump the full view hierarchy

Attach to the process and print the subtree description of the key window's
content view. This shows every view, its frame, visibility flags, and backing
layer.

```bash
lldb -p <PID> \
  -o 'expr -l objc -O -- [[(NSWindow*)[NSApp keyWindow] contentView] _subtreeDescription]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

If `keyWindow` returns nil (the window may lose key status when lldb attaches),
find the window address first:

```bash
lldb -p <PID> \
  -o 'expr -l objc -O -- [NSApp windows]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

Then use the address directly:

```bash
lldb -p <PID> \
  -o 'expr -l objc -O -- [[(NSWindow*)<ADDRESS> contentView] _subtreeDescription]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

### Reading the output

Each line in the dump follows this format:

```
[FLAGS] h=--- v=--- ClassName 0xADDRESS "title" f=(x,y,w,h) b=(-) => <LayerClass>
```

Key flags:
- `H` — view is hidden; `h` — hidden by ancestor. Hidden views are skipped by
  `hitTest`.
- `W` — `wantsLayer` is true; `w` — ancestor wants layer.
- `A` — `autoresizesSubviews`.
- `F` — `isFlipped` (y=0 at top instead of bottom).

Key properties:
- `f=(x,y,w,h)` — the view's frame in its superview's coordinate system.
- Sibling order — views are listed top-to-bottom in the dump, but the LAST
  sibling is frontmost (drawn on top and receives hit tests first).

### 3. Filter to views of interest

Pipe through grep to focus on specific view classes:

```bash
lldb -p <PID> \
  -o 'expr -l objc -O -- [[(NSWindow*)<ADDRESS> contentView] _subtreeDescription]' \
  -o 'detach' -o 'quit' 2>/dev/null | grep -E '(ClassName1|ClassName2)'
```

### 4. Inspect a specific view's properties

Use the view's address from the hierarchy dump to query individual properties.

**Subviews:**
```bash
lldb -p <PID> \
  -o 'expr -l objc -O -- @import AppKit; [(NSView*)<ADDRESS> subviews]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

**Registered drag types:**
```bash
lldb -p <PID> \
  -o 'expr -l objc -O -- @import AppKit; [(NSView*)<ADDRESS> registeredDraggedTypes]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

**Frame and bounds:**
```bash
lldb -p <PID> \
  -o 'expr -l objc -- @import AppKit; (CGRect)[(NSView*)<ADDRESS> frame]' \
  -o 'expr -l objc -- @import AppKit; (CGRect)[(NSView*)<ADDRESS> bounds]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

**Hidden state:**
```bash
lldb -p <PID> \
  -o 'expr -l objc -- @import AppKit; (BOOL)[(NSView*)<ADDRESS> isHidden]' \
  -o 'expr -l objc -- @import AppKit; (BOOL)[(NSView*)<ADDRESS> isHiddenOrHasHiddenAncestor]' \
  -o 'detach' -o 'quit' 2>/dev/null
```

### 5. Add temporary diagnostics (when static inspection isn't enough)

For dynamic issues (events only fail during interaction), add temporary
`fputs` logging to the relevant view's event methods (`hitTest`, `mouseDown`,
`draggingEntered`, `keyDown`, etc.):

```swift
fputs("[DIAG] ClassName.methodName — relevant state\n", stderr)
```

Rebuild and relaunch. Attempt the interaction and check stderr for `[DIAG]`
output. The presence or absence of log lines tells you which views are and
aren't receiving events.

**Remove all `[DIAG]` instrumentation before committing.**

## Tips

- Run multiple lldb commands in a single attach by chaining `-o` flags. Each
  attach/detach cycle pauses the app briefly.
- The dump can be large. Redirect to a file for easier searching:
  `lldb ... 2>/dev/null > /tmp/hierarchy.txt`
- Views with zero-size frames (`f=(0,0,0,0)`) are effectively invisible to
  hit testing but may still exist in the hierarchy.
- A view's `hitTest` override can change routing behavior without being visible
  in the static dump. Check the source for custom `hitTest` implementations
  when the hierarchy looks correct but events aren't arriving.
