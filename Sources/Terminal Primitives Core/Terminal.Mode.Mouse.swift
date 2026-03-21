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
    /// Mouse tracking mode escape sequences.
    ///
    /// DEC private modes for mouse event reporting.
    /// Enable SGR encoding (1006) alongside a tracking mode for best results.
    public enum Mouse {
        /// Normal tracking: press and release events only (mode 1000).
        public enum Normal {
            public static let enable: Swift.String = "\u{1B}[?1000h"
            public static let disable: Swift.String = "\u{1B}[?1000l"
        }

        /// Button-event tracking: press, release, and drag (mode 1002).
        public enum Button {
            public static let enable: Swift.String = "\u{1B}[?1002h"
            public static let disable: Swift.String = "\u{1B}[?1002l"
        }

        /// Any-event tracking: all mouse events including motion (mode 1003).
        public enum `Any` {
            public static let enable: Swift.String = "\u{1B}[?1003h"
            public static let disable: Swift.String = "\u{1B}[?1003l"
        }

        /// SGR extended coordinates (mode 1006). Combine with a tracking mode.
        public enum SGR {
            public static let enable: Swift.String = "\u{1B}[?1006h"
            public static let disable: Swift.String = "\u{1B}[?1006l"
        }
    }
}
