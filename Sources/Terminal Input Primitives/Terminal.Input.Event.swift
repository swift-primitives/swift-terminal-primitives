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

/// A terminal input event.
///
/// Represents a single parsed input event from the terminal. Events are
/// produced by ``Terminal.Input.Parser`` from raw byte sequences.
extension Terminal.Input {
    public enum Event: Sendable, Equatable {
        /// A keyboard event.
        case key(Key)

        /// A mouse event.
        case mouse(Mouse)

        /// A terminal resize event.
        case resize(Terminal.Size)

        /// A bracketed paste event.
        case paste(Swift.String)
    }
}
