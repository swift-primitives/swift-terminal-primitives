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

/// Errors produced by the terminal input parser.
extension Terminal.Input.Parser {
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The input buffer is empty—no bytes to parse.
        case emptyInput

        /// The sequence is incomplete—more bytes needed.
        ///
        /// The buffer position is restored to before the sequence start.
        /// The I/O layer should wait for more data and retry.
        case incompleteSequence

        /// The byte sequence is not a recognized terminal input encoding.
        case unrecognizedSequence

        /// The byte sequence is not valid UTF-8.
        case invalidUTF8
    }
}
