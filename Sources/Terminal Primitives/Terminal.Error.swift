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

public import Kernel_Primitives

extension Terminal {
    /// Terminal operation error.
    ///
    /// Wraps kernel-level errors with terminal-specific context.
    public struct Error: Swift.Error, Sendable {
        /// The operation that failed.
        public let operation: Operation

        /// The underlying cause.
        public let underlying: Underlying

        /// Creates a terminal error.
        public init(operation: Operation, underlying: Underlying) {
            self.operation = operation
            self.underlying = underlying
        }
    }
}

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

extension Terminal.Error {
    /// Underlying error cause.
    public enum Underlying: Sendable {
        /// Kernel-level error.
        case kernel(Kernel.Error)

        /// Windows console error.
        case console(Kernel.Console.Error)

        /// Operation not supported on this platform.
        case unsupported
    }
}

extension Terminal.Error: CustomStringConvertible {
    public var description: Swift.String {
        switch underlying {
        case .kernel(let error):
            return "Terminal.\(operation): \(error)"
        case .console(let error):
            return "Terminal.\(operation): \(error)"
        case .unsupported:
            return "Terminal.\(operation): not supported on this platform"
        }
    }
}
