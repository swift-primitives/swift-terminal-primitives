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
        /// The stream to check for interactivity.
        public let stream: Terminal.Stream

        /// Creates an interactive query for the given stream.
        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

// Note: `callAsFunction()` method for Terminal.Stream.Interactive is provided via
// extension in swift-iso-9945 (POSIX) or swift-windows-primitives (Windows)
