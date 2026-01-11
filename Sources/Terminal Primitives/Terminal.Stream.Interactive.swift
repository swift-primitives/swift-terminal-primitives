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

extension Terminal.Stream {
    /// Accessor for interactivity queries.
    public var interactive: Interactive {
        Interactive(stream: self)
    }

    /// Interactivity query accessor.
    ///
    /// Provides a callable interface for checking if a stream is interactive.
    public struct Interactive: Sendable {
        internal let stream: Terminal.Stream

        internal init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

extension Terminal.Stream.Interactive {
    /// Check if this stream is attached to an interactive terminal.
    ///
    /// Returns `true` if the stream is connected to a terminal device,
    /// `false` if it's a pipe, file, or other non-interactive destination.
    ///
    /// Platform selection is handled internally - callers see a unified API.
    public func callAsFunction() -> Bool {
        Terminal.Backend.isInteractive(stream: stream)
    }
}
