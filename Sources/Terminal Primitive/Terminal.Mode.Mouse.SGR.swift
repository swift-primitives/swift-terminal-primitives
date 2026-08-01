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
    /// SGR extended coordinates (mode 1006).
    ///
    /// Combine with a tracking mode for cleaner, range-unbounded coordinates.
    public enum SGR {}
}

extension Terminal.Mode.Mouse.SGR {
    /// Escape sequence that enables SGR extended-coordinate encoding.
    public static let enable: Swift.String = "\u{1B}[?1006h"

    /// Escape sequence that disables SGR extended-coordinate encoding.
    public static let disable: Swift.String = "\u{1B}[?1006l"
}
