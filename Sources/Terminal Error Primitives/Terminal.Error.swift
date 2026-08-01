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

extension Terminal.Error: CustomStringConvertible {
    /// A human-readable description of the failed operation and its cause.
    public var description: Swift.String {
        switch underlying {
        case .kernel(let error):
            return "Terminal.\(operation): \(error)"

        case .platform(let error):
            return "Terminal.\(operation): \(error)"

        case .unsupported:
            return "Terminal.\(operation): not supported on this platform"
        }
    }
}
