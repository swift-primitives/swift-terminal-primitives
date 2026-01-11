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

extension Terminal.Mode.Raw {
    /// Token for restoring terminal mode after entering raw mode.
    ///
    /// This is a move-only type that ensures the previous terminal mode
    /// is restored either explicitly via ``restore()`` or automatically on deinit.
    public struct Token: ~Copyable, Sendable {
        private let stream: Terminal.Stream
        private let previous: Previous
        private var restored: Bool = false

        internal init(stream: Terminal.Stream, previous: Previous) {
            self.stream = stream
            self.previous = previous
        }

        /// Restore the previous terminal mode.
        ///
        /// - Throws: ``Terminal.Error`` if restoration fails
        public mutating func restore() throws(Terminal.Error) {
            guard !restored else { return }
            try Terminal.Backend.exitRaw(stream: stream, previous: previous)
            restored = true
        }

        deinit {
            guard !restored else { return }
            // Best-effort restore on deinit
            do {
                try Terminal.Backend.exitRaw(stream: stream, previous: previous)
            } catch {
                // Silently ignore errors during deinit
            }
        }
    }
}

extension Terminal.Mode.Raw.Token {
    /// Previous terminal state (platform-specific).
    internal enum Previous: Sendable {
        #if !os(Windows)
        case posix(Kernel.Termios.Attributes)
        #endif

        #if os(Windows)
        case windows(UInt32)  // Console mode flags
        #endif
    }
}
