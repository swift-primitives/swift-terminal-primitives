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

extension Terminal.Mode.Mouse {
    /// Any-event tracking: all mouse events including motion (mode 1003).
    public enum `Any` {}
}

extension Terminal.Mode.Mouse.`Any` {
    /// Escape sequence that enables any-event (motion) mouse tracking.
    public static let enable: Swift.String = "\u{1B}[?1003h"

    /// Escape sequence that disables any-event mouse tracking.
    public static let disable: Swift.String = "\u{1B}[?1003l"
}
