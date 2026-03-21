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
    /// Accessor for read operations on this stream.
    public var read: Read {
        Read(stream: self)
    }

    /// Read operations on terminal streams.
    ///
    /// ## Platform Implementation
    ///
    /// Syscall implementations are in platform-specific packages:
    /// - POSIX: `swift-iso-9945`
    public struct Read: Sendable {
        /// The stream to read from.
        public let stream: Terminal.Stream

        /// Creates a read accessor for the given stream.
        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

// Note: `callAsFunction(into:)` method for Terminal.Stream.Read is provided via
// extension in swift-iso-9945 (POSIX)
