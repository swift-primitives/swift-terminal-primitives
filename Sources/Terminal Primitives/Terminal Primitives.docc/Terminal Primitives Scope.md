# Terminal Primitives Scope

`swift-terminal-primitives` provides the **terminal-abstraction substrate**: the
`Terminal` namespace and its semantic vocabulary for terminal I/O — standard
streams (`Terminal.Stream`), terminal dimensions (`Terminal.Size`), mode control
(`Terminal.Mode` — raw / keyboard / mouse / paste / screen escape sequences), and
the typed terminal error (`Terminal.Error`). These compose over kernel-level
terminal operations (POSIX `Kernel.TTY` / `Kernel.Termios`, or the Windows Console
API) without exposing platform-specific APIs to callers; the actual syscall
implementations are added by the platform layer (`swift-iso-9945` POSIX,
`swift-windows-primitives`).

## Per-[MOD-031] shape

The package follows `[MOD-031]` per-sub-namespace decomposition: `Terminal Primitive`
is the layer-invariant namespace target per `[MOD-017]`, and each external-dep-
bearing sub-namespace is its own target. There is no implementation-bearing
`Terminal Primitives Core` target — the legacy `[MOD-001]` Core convention is
deprecated. During the L1 core-dissolution sweep (2026-06-23) the Core's content
was relocated (the stdlib-only decls to the `Terminal Primitive` root, the
`Error_Primitives`-bearing `Terminal.Error` to the new `Terminal Error Primitives`
sub-namespace) and the `Terminal Primitives Core` target was reduced to a
time-boxed exports-only shim (removed in the cleanup wave).

## Owner targets

- **Terminal Primitive** — the `public enum Terminal {}` namespace target. Zero
  external deps per `[MOD-017]`'s invariant. Owns the `Terminal.Stream` enum and
  its `.interactive` / `.read` / `.write` accessors, `Terminal.Size`, the
  `Terminal.Mode` namespace and accessor (`.raw` and the keyboard / mouse / paste /
  screen escape-sequence enums), and the `Terminal.Backend` namespace marker. All
  stdlib-only; the syscall extensions are added at L2.
- **Terminal Error Primitives** — the `Terminal.Error` struct (operation +
  underlying cause) and its `Operation` / `Underlying` enums. Wraps kernel- and
  platform-level errors with terminal-specific context. Depends on
  `Terminal Primitive` (to extend `Terminal`) and `Error Primitives` (the wrapped
  error type) per `[MOD-002]`-amended.
- **Terminal Primitives** — umbrella; re-exports `Terminal Primitive` +
  `Terminal Error Primitives` so consumers needing the union write
  `import Terminal_Primitives`.
- **Terminal Primitives Core** — DEPRECATED time-boxed shim (exports-only).
  Re-exports the pre-migration Core surface (`Terminal Primitive` +
  `Terminal Error Primitives` + the `Error_Primitives` funnel) so no consumer
  (`swift-terminal-input`, `kernel` L3) breaks during the sweep. Removed in the
  cleanup wave.
- **Terminal Primitives Test Support** — published test-fixtures product.

## Out of scope

- Terminal **input** parsing (escape-sequence / key-event decoding) —
  `swift-terminal-input-primitives`.
- Platform syscall **implementations** of the L1-declared surface — added by
  extension in `swift-iso-9945` (POSIX) and `swift-windows-primitives` (Windows).

## Evaluation rule

Sub-target additions are evaluated against this scope.

- A proposed addition that is a **stdlib-only terminal-abstraction decl** (a
  namespace, a stream / size / mode value or accessor, an escape-sequence
  constant) lands in the zero-dep `Terminal Primitive` root.
- A proposed addition that **requires an external dependency** lands as its own
  sub-namespace target per `[MOD-031]`, declaring that dependency itself.
