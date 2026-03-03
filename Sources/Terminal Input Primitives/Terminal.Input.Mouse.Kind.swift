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

/// The kind of mouse event.
extension Terminal.Input.Mouse {
    public enum Kind: Sendable, Equatable {
        /// A button was pressed.
        case press(Button)

        /// A button was released.
        case release(Button)

        /// Mouse moved without any button held.
        case move

        /// Mouse moved with a button held.
        case drag(Button)

        /// Scroll wheel up.
        case scrollUp

        /// Scroll wheel down.
        case scrollDown

        /// Scroll wheel left.
        case scrollLeft

        /// Scroll wheel right.
        case scrollRight
    }
}
