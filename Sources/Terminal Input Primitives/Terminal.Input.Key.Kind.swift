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

/// The kind of key event.
///
/// Only meaningful when the Kitty keyboard protocol is active.
/// Standard VT sequences do not distinguish press from repeat.
extension Terminal.Input.Key {
    public enum Kind: Sendable, Equatable {
        /// Initial key press.
        case press

        /// Key held down (auto-repeat).
        case `repeat`

        /// Key released.
        case release
    }
}
