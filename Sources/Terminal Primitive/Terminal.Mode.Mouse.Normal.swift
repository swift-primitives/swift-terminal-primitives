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
    /// Normal tracking: press and release events only (mode 1000).
    public enum Normal {}
}

extension Terminal.Mode.Mouse.Normal {
    /// Escape sequence that enables press/release mouse tracking.
    public static let enable: Swift.String = "\u{1B}[?1000h"

    /// Escape sequence that disables press/release mouse tracking.
    public static let disable: Swift.String = "\u{1B}[?1000l"
}
