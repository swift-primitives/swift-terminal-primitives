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

internal import Kernel_Terminal_Primitives

extension Terminal {
    /// Standard I/O streams.
    ///
    /// Represents the three standard streams: stdin (0), stdout (1), stderr (2).
    /// Provides access to terminal operations on each stream.
    public enum Stream: Int32, Sendable, Hashable, CaseIterable {
        /// Standard input (file descriptor 0).
        case stdin = 0

        /// Standard output (file descriptor 1).
        case stdout = 1

        /// Standard error (file descriptor 2).
        case stderr = 2
    }
}
