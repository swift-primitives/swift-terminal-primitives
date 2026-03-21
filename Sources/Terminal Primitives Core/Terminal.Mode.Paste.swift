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
    /// Bracketed paste mode escape sequences (mode 2004).
    public enum Paste {
        public static let enable: Swift.String = "\u{1B}[?2004h"
        public static let disable: Swift.String = "\u{1B}[?2004l"
    }
}
