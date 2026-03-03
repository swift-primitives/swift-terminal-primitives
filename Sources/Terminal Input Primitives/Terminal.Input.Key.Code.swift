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

/// Identifies the key that was pressed.
///
/// Covers standard terminal keys, function keys, navigation keys,
/// and Kitty keyboard protocol functional keys.
extension Terminal.Input.Key {
    public enum Code: Sendable, Equatable {
        /// A printable character key.
        case character(Unicode.Scalar)

        /// A function key (F1–F24).
        case function(UInt8)

        /// Arrow keys.
        case up
        case down
        case left
        case right

        /// Common action keys.
        case enter
        case escape
        case tab
        case backspace
        case delete

        /// Navigation keys.
        case home
        case end
        case pageUp
        case pageDown
        case insert

        /// Reverse tab (Shift+Tab).
        case backtab

        /// A Kitty keyboard protocol functional key.
        ///
        /// The value is the Unicode codepoint from the private use area
        /// (U+E000–U+E07F) assigned by the Kitty keyboard protocol.
        case kitty(UInt32)
    }
}
