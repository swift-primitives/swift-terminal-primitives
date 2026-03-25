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
        /// The stream this token is for.
        public let stream: Terminal.Stream
        /// The previous terminal state (platform-specific).
        public let previous: Previous
        /// Whether the mode has been restored.
        public var restored: Bool = false

        /// Creates a token with the given stream and previous state.
        public init(stream: Terminal.Stream, previous: Previous) {
            self.stream = stream
            self.previous = previous
        }

        // Note: `restore()` method is provided via extension in swift-iso-9945 (POSIX)
        // or swift-windows-primitives (Windows)

        // Note: deinit restoration is handled by the platform layer via
        // Terminal.Mode.Raw.Token._restoreOnDeinit(stream:previous:)
    }
}

extension Terminal.Mode.Raw.Token {
    /// Previous terminal state (platform-specific).
    public enum Previous: Sendable {
        #if !os(Windows)
        case posix(Kernel.Termios.Attributes)
        #endif

        #if os(Windows)
        case windows(UInt32)  // Console mode flags
        #endif
    }
}
