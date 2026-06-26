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

extension Terminal.Mode {
    /// Alternate screen buffer escape sequences (mode 1049).
    public enum Screen {
        /// Escape sequence that switches to the alternate screen buffer.
        public static let enable: Swift.String = "\u{1B}[?1049h"

        /// Escape sequence that restores the primary screen buffer.
        public static let disable: Swift.String = "\u{1B}[?1049l"
    }
}
