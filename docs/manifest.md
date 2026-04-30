# OpenMUX Manifesto

## 1. Why OpenMUX exists

Terminals are the backbone of software development.

Yet modern terminal tools are increasingly:

* Opinionated toward specific workflows
* Bloated with features most developers don’t need
* Slow to evolve in the areas that actually matter

OpenMUX exists to reclaim the terminal as:

> A fast, flexible, and *hackable* workspace for developers.

Not for agents.
Not for hype cycles.
For people who build things.

---

## 2. Core Philosophy

### 2.1 Open by design

OpenMUX is not just open source.
It is *open at its core*.

Every part of the system should be:

* Inspectable
* Replaceable
* Extendable

If something doesn’t work for you, you shouldn’t need to fork the entire project.
You should be able to hook into it and change it.

---

### 2.2 Terminal first

The terminal is the product.

Not AI.
Not a browser.
Not a sidecar experience.

OpenMUX focuses on:

* Reliable terminal rendering (via Ghostty)
* Fast input and output
* Stable long-running sessions

Everything else is secondary.

---

### 2.3 Tools, not opinions

OpenMUX does not dictate your workflow.

It should work equally well for:

* Shell users
* tmux users
* AI-assisted workflows
* SSH-heavy workflows
* Backend, frontend, and infra engineers

We provide primitives.
You build your workflow.

---

### 2.4 Hackability over features

We will always prefer:

> A small, composable system over a large, rigid one.

Instead of adding features directly into the core, we aim to:

* Expose hooks
* Provide extension points
* Enable plugins

The goal is not to build everything.
The goal is to make everything *buildable*.

---

### 2.5 Sensible defaults

Power should not come at the cost of usability.

OpenMUX should feel good out of the box:

* Tabs for projects
* Clear session management
* Useful notifications
* Thoughtful keybindings

You should not need to configure it for hours before it becomes useful.

---

### 2.6 International-first

Developers are global.

Keyboard handling must work for:

* EU layouts
* Alt/Option combinations
* Dead keys and compose keys

Broken input is not a minor bug.
It is a blocker.

OpenMUX treats correct input handling as a core feature, not an edge case.

---

## 3. What OpenMUX is NOT

* Not an AI-first terminal
* Not a browser inside a terminal
* Not a monolithic “do everything” tool
* Not tied to a single vendor or ecosystem

---

## 4. Architecture Principles

### 4.1 Built on strong foundations

OpenMUX uses libghostty for terminal rendering.

We do not reinvent the hardest part.
We build on top of the best available foundation.

---

### 4.2 Hookable core

The system is designed around hooks:

* Lifecycle hooks (startup, shutdown)
* Session hooks (create, destroy, focus)
* Command hooks (run, complete, fail)
* UI hooks (render, layout changes)
* Input hooks (keybindings, overrides)

If you want to change behavior, you should be able to do it without patching the core.

---

### 4.3 Plugin-first ecosystem

Plugins are not an afterthought.

They are a primary way to extend OpenMUX.

Examples:

* AI integrations (Claude, Codex, etc.)
* Project detection
* Custom notifications
* Workflow automation

---

### 4.4 Performance is a feature

* Fast startup
* Low memory overhead
* Smooth rendering
* No unnecessary background processes

If something slows the terminal down, it doesn’t belong in the core.

---

## 5. Licensing Philosophy

OpenMUX is released under a permissive license (Apache-2.0).

This ensures:

* Anyone can build on it
* Companies can adopt it without friction
* The ecosystem can grow freely

We believe openness should enable usage, not restrict it.

---

## 6. The Long-Term Vision

OpenMUX aims to become:

> The standard foundation for modern terminal workspaces.

Not by locking users in,
but by being:

* Simple
* Reliable
* Extensible

---

## 7. Guiding Principle

At every decision point, we ask:

> Does this make the terminal more powerful, more flexible, and more open?

If the answer is no,
we don’t ship it.

---

## 8. Final Words

OpenMUX is built for developers who:

* Care about their tools
* Want control over their workflow
* Prefer systems they can understand and modify

This is not a finished product.

It is a foundation.

Build on it.

