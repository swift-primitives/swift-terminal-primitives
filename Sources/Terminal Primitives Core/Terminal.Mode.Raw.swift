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

extension Terminal.Mode {
    /// Raw mode operations.
    ///
    /// Raw mode disables line buffering, echo, and signal processing,
    /// allowing character-by-character input.
    public struct Raw: Sendable {
        /// The stream this raw mode instance is for.
        public let stream: Terminal.Stream

        /// Creates a raw mode instance for the given stream.
        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

// Note: `enter()` method is provided via extension in swift-iso-9945 (POSIX)
// or swift-windows-primitives (Windows)
