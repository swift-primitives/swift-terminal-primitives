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
        internal let stream: Terminal.Stream

        internal init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

extension Terminal.Mode.Raw {
    /// Enter raw mode on this stream.
    ///
    /// Returns a token that must be used to restore the previous mode.
    /// The token will attempt to restore on deinit if not explicitly restored.
    ///
    /// - Returns: A token to restore the previous terminal mode
    /// - Throws: ``Terminal.Error`` if entering raw mode fails
    public func enter() throws(Terminal.Error) -> Token {
        try Terminal.Backend.enterRaw(stream: stream)
    }
}
