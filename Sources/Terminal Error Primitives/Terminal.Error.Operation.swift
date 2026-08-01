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

public import Terminal_Primitive

extension Terminal.Error {
    /// Terminal operations that can fail.
    public enum Operation: Sendable, Hashable {
        /// Querying terminal size.
        case querySize

        /// Entering raw mode.
        case enterRaw

        /// Exiting raw mode (restoring).
        case exitRaw

        /// Enabling VT processing (Windows).
        case enableVT
    }
}
