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

public import Kernel_Primitives

/// Internal platform abstraction layer.
///
/// All platform-specific code is centralized here. Public APIs call into
/// Backend, which dispatches to the appropriate Kernel primitives.
extension Terminal {
    internal enum Backend {}
}

// MARK: - Interactivity

extension Terminal.Backend {
    /// Check if stream is interactive (platform selection centralized here).
    static func isInteractive(stream: Terminal.Stream) -> Bool {
        #if os(Windows)
            return _windowsIsInteractive(stream: stream)
        #else
            return Kernel.TTY.isTTY(fd: stream.rawValue)
        #endif
    }

    #if os(Windows)
    private static func _windowsIsInteractive(stream: Terminal.Stream) -> Bool {
        let handle = stream.windowsHandle
        return (try? Kernel.Console.Mode.get(handle: handle)) != nil
    }
    #endif
}

// MARK: - Size

extension Terminal.Backend {
    /// Query terminal size (platform selection centralized here).
    static func size(stream: Terminal.Stream) throws(Terminal.Error) -> Terminal.Size {
        #if os(Windows)
            return try _windowsSize(stream: stream)
        #else
            return try _posixSize(stream: stream)
        #endif
    }

    #if !os(Windows)
    private static func _posixSize(stream: Terminal.Stream) throws(Terminal.Error) -> Terminal.Size {
        do {
            let kernelSize = try Kernel.TTY.Size.query(fd: stream.rawValue)
            return Terminal.Size(rows: kernelSize.rows, columns: kernelSize.columns)
        } catch {
            throw Terminal.Error(operation: .querySize, underlying: .kernel(error))
        }
    }
    #endif

    #if os(Windows)
    private static func _windowsSize(stream: Terminal.Stream) throws(Terminal.Error) -> Terminal.Size {
        let handle = stream.windowsHandle
        do {
            let buffer = try Kernel.Console.Buffer.query(handle: handle)
            return Terminal.Size(
                rows: UInt16(buffer.window.height),
                columns: UInt16(buffer.window.width)
            )
        } catch {
            throw Terminal.Error(operation: .querySize, underlying: .console(error))
        }
    }
    #endif
}

// MARK: - Raw Mode

extension Terminal.Backend {
    /// Enter raw mode (platform selection centralized here).
    static func enterRaw(stream: Terminal.Stream) throws(Terminal.Error) -> Terminal.Mode.Raw.Token {
        #if os(Windows)
            return try _windowsEnterRaw(stream: stream)
        #else
            return try _posixEnterRaw(stream: stream)
        #endif
    }

    #if !os(Windows)
    private static func _posixEnterRaw(stream: Terminal.Stream) throws(Terminal.Error) -> Terminal.Mode.Raw.Token {
        do {
            let original = try Kernel.Termios.Attributes.get(fd: stream.rawValue)
            let raw = original.withRaw()
            try Kernel.Termios.Attributes.set(raw, fd: stream.rawValue)
            return Terminal.Mode.Raw.Token(stream: stream, previous: .posix(original))
        } catch {
            throw Terminal.Error(operation: .enterRaw, underlying: .kernel(error))
        }
    }
    #endif

    #if os(Windows)
    private static func _windowsEnterRaw(stream: Terminal.Stream) throws(Terminal.Error) -> Terminal.Mode.Raw.Token {
        let handle = stream.windowsHandle

        do {
            // Save original mode
            let original = try Kernel.Console.Mode.get(handle: handle)

            // Configure raw mode
            // Remove line input and echo for stdin
            // Enable virtual terminal processing for stdout/stderr
            let rawMode: Kernel.Console.Mode
            if stream == .stdin {
                rawMode = original
                    .subtracting(.lineInput)
                    .subtracting(.echoInput)
                    .subtracting(.processedInput)
                    .union(.virtualTerminalInput)
            } else {
                rawMode = original
                    .union(.virtualTerminalProcessing)
                    .union(.disableNewlineAutoReturn)
            }

            try Kernel.Console.Mode.set(rawMode, handle: handle)
            return Terminal.Mode.Raw.Token(stream: stream, previous: .windows(original.rawValue))
        } catch {
            throw Terminal.Error(operation: .enterRaw, underlying: .console(error))
        }
    }
    #endif

    /// Exit raw mode (platform selection centralized here).
    static func exitRaw(stream: Terminal.Stream, previous: Terminal.Mode.Raw.Token.Previous) throws(Terminal.Error) {
        #if os(Windows)
            try _windowsExitRaw(stream: stream, previous: previous)
        #else
            try _posixExitRaw(stream: stream, previous: previous)
        #endif
    }

    #if !os(Windows)
    private static func _posixExitRaw(stream: Terminal.Stream, previous: Terminal.Mode.Raw.Token.Previous) throws(Terminal.Error) {
        guard case .posix(let attrs) = previous else {
            throw Terminal.Error(operation: .exitRaw, underlying: .unsupported)
        }
        do {
            try Kernel.Termios.Attributes.set(attrs, fd: stream.rawValue)
        } catch {
            throw Terminal.Error(operation: .exitRaw, underlying: .kernel(error))
        }
    }
    #endif

    #if os(Windows)
    private static func _windowsExitRaw(stream: Terminal.Stream, previous: Terminal.Mode.Raw.Token.Previous) throws(Terminal.Error) {
        guard case .windows(let mode) = previous else {
            throw Terminal.Error(operation: .exitRaw, underlying: .unsupported)
        }
        let handle = stream.windowsHandle
        do {
            try Kernel.Console.Mode.set(Kernel.Console.Mode(rawValue: mode), handle: handle)
        } catch {
            throw Terminal.Error(operation: .exitRaw, underlying: .console(error))
        }
    }
    #endif
}
