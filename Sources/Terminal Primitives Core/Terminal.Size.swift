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

extension Terminal {
    /// Terminal window size in rows and columns.
    public struct Size: Sendable, Hashable {
        /// Number of rows (lines).
        public let rows: UInt16

        /// Number of columns (characters per line).
        public let columns: UInt16

        /// Creates a size value.
        public init(rows: UInt16, columns: UInt16) {
            self.rows = rows
            self.columns = columns
        }
    }
}

// Note: `query(stream:)` method is provided via extension in swift-iso-9945 (POSIX)
// or swift-windows-primitives (Windows)
