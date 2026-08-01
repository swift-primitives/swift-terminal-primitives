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
    /// Mode operations accessor for a specific stream.
    public struct Access: Sendable {
        internal let stream: Terminal.Stream

        internal init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

extension Terminal.Mode.Access {
    /// Raw mode accessor.
    public var raw: Terminal.Mode.Raw {
        Terminal.Mode.Raw(stream: stream)
    }
}
