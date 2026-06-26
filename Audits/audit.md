# Audit: swift-terminal-primitives

## Legacy — Consolidated 2026-04-08

### From: swift-institute/Research/audits/implementation-naming-2026-03-20/swift-data-structures-batch.md (2026-03-20)

**Implementation + naming audit**

HIGH=0, MEDIUM=1, LOW=2, INFO=0
Finding IDs: TERM-001, TERM-002, TERM-003

---

### From: swift-institute/Research/platform-compliance-audit.md (2026-03-19)

**Skill**: platform — [PLAT-ARCH-001-010], [PATTERN-001], [PATTERN-004a], [PATTERN-005]

| # | Severity | Rule | Location | Finding | Status |
|---|----------|------|----------|---------|--------|
| H-51 | HIGH | [PLAT-ARCH-008] | Terminal.Mode.Raw.Token.swift:44,48 | `#if !os(Windows)` for POSIX termios vs Windows console mode. Fix: Move terminal raw mode token to platform stack (`Kernel.Terminal.Mode.Raw`). | OPEN — Missing Kernel abstraction |
| H-52 | HIGH | [PLAT-ARCH-008] | Terminal.Stream.swift:31 | `#if os(Windows)` for Windows console handle mapping. Fix: Abstract through Kernel. | OPEN |
