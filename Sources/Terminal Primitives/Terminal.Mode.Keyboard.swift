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
    /// Kitty keyboard protocol escape sequences.
    public enum Keyboard {
        /// Enable with disambiguate flag (flags=1).
        public static let enable: Swift.String = "\u{1B}[>1u"
        /// Disable (pop keyboard mode).
        public static let disable: Swift.String = "\u{1B}[<u"
    }
}
