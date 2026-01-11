// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-terminal-primitives open source project
//
// Copyright (c) 2024 Coen ten Thije Boonkkamp and the swift-terminal-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

/// Terminal primitives namespace.
///
/// Provides semantic abstractions over kernel-level terminal operations:
/// - ``Stream`` - Standard I/O streams (stdin/stdout/stderr)
/// - ``Size`` - Terminal dimensions
/// - ``Mode`` - Terminal mode control (raw/cooked)
///
/// These compose over ``Kernel.TTY`` and ``Kernel.Termios`` (POSIX) or
/// ``Kernel.Console`` (Windows) without exposing platform-specific APIs
/// to callers.
///
/// ## Example
///
/// ```swift
/// // Check if stdout is a terminal
/// if Terminal.Stream.stdout.interactive() {
///     // Query terminal size
///     let size = try Terminal.Size.query()
///     print("Terminal is \(size.columns)x\(size.rows)")
///
///     // Enter raw mode
///     let token = try Terminal.Stream.stdin.mode.raw.enter()
///     defer { try? token.restore() }
///     // Read single keystrokes...
/// }
/// ```
public enum Terminal {}
