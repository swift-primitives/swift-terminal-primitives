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

/// A mouse input event.
///
/// Represents a mouse action with position and modifier information.
/// Coordinates are 1-based, matching the SGR mouse encoding.
extension Terminal.Input {
    public struct Mouse: Sendable, Equatable {
        /// The kind of mouse event (press, release, move, drag, scroll).
        public var kind: Kind

        /// The column position (1-based).
        public var column: UInt16

        /// The row position (1-based).
        public var row: UInt16

        /// Active modifier keys during the mouse event.
        public var modifiers: Key.Modifiers

        public init(
            kind: Kind,
            column: UInt16,
            row: UInt16,
            modifiers: Key.Modifiers = []
        ) {
            self.kind = kind
            self.column = column
            self.row = row
            self.modifiers = modifiers
        }
    }
}
