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

extension Terminal {
    /// Terminal mode operations namespace.
    public enum Mode {}
}

extension Terminal.Stream {
    /// Accessor for mode operations on this stream.
    public var mode: Terminal.Mode.Access {
        Terminal.Mode.Access(stream: self)
    }
}

extension Terminal.Mode {
    /// Mode operations accessor for a specific stream.
    public struct Access: Sendable {
        internal let stream: Terminal.Stream

        internal init(stream: Terminal.Stream) {
            self.stream = stream
        }

        /// Raw mode accessor.
        public var raw: Raw {
            Raw(stream: stream)
        }
    }
}
