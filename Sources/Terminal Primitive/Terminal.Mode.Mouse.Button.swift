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
    /// Button-event tracking: press, release, and drag (mode 1002).
    public enum Button {}
}

extension Terminal.Mode.Mouse.Button {
    /// Escape sequence that enables button-event (drag) mouse tracking.
    public static let enable: Swift.String = "\u{1B}[?1002h"

    /// Escape sequence that disables button-event mouse tracking.
    public static let disable: Swift.String = "\u{1B}[?1002l"
}
