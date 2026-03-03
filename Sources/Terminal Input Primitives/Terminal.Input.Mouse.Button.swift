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

/// A mouse button.
extension Terminal.Input.Mouse {
    public enum Button: Sendable, Equatable {
        /// Left mouse button (button 1).
        case left

        /// Middle mouse button (button 2).
        case middle

        /// Right mouse button (button 3).
        case right

        /// Back/backward button (button 8).
        case backward

        /// Forward button (button 9).
        case forward
    }
}
