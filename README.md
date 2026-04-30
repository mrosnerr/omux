<p align="center">
  <img src="./assets/logo.png" alt="OpenMUX logo" width="900" />
</p>

<h1 align="center">OpenMUX</h1>

<p align="center">
  A fast, flexible, and hackable terminal workspace for developers.
</p>

<p align="center">
  <a href="./docs/manifest.md">Manifesto</a>
</p>

---

## Why OpenMUX

OpenMUX exists to reclaim the terminal as a workspace that is fast, reliable, and open to change.

It is built for developers who want tools they can understand, adapt, and build on, without being forced into a single workflow or a bloated all-in-one platform.

## Principles

- **Open by design** — core behavior should be inspectable, replaceable, and extendable.
- **Terminal first** — the terminal is the product, not a sidecar to something else.
- **Tools, not opinions** — OpenMUX should support shell users, tmux users, SSH-heavy workflows, and AI-assisted workflows equally well.
- **Hackability over features** — expose hooks and extension points instead of hardcoding every workflow into the core.
- **Sensible defaults** — useful tabs, session management, notifications, and keybindings should work out of the box.
- **International-first** — keyboard handling must work correctly across layouts, modifiers, and compose/dead key input.

## What OpenMUX is

OpenMUX is aiming to be a modern foundation for terminal workspaces:

- Built on strong foundations with **libghostty** for terminal rendering
- Designed around a **hookable core**
- Extended through a **plugin-first ecosystem**
- Focused on **performance as a feature**

## What OpenMUX is not

- Not an AI-first terminal
- Not a browser inside a terminal
- Not a monolithic "do everything" tool
- Not tied to a single vendor or ecosystem

## Architecture Direction

The architecture is intentionally small and composable. OpenMUX is designed to expose hooks around:

- Lifecycle events
- Session management
- Command execution
- UI and layout changes
- Input and keybinding behavior

Plugins are a primary extension model, not an afterthought. That includes space for AI integrations, project-aware workflows, notifications, and automation without forcing those concerns into the core product.

## Vision

OpenMUX aims to become the standard foundation for modern terminal workspaces by staying:

- **Simple**
- **Reliable**
- **Extensible**

This is not positioned as a finished product. It is a foundation meant to be built on.

## Status

OpenMUX is in its early stage, and the current direction is defined in the [manifest](./docs/manifest.md).

## License

OpenMUX is released under **Apache-2.0**. See [LICENSE](./LICENSE).

---

<div align="center">

<b>Made for developers who want the terminal to stay fast, flexible, and open.</b>

Made with ❤️ in Skåne. A <a href="https://fingergun.dev/">Finger Gun</a> project, making nothing into something.

</div>
