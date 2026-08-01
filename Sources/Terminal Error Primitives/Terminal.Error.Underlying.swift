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

public import Error_Primitives
public import Terminal_Primitive

extension Terminal.Error {
    /// Underlying error cause.
    public enum Underlying: Sendable {
        /// Kernel-level error.
        case kernel(Error_Primitives.Error)

        /// Platform-specific error (e.g., Windows Console API failure).
        case platform(Error_Primitives.Error)

        /// Operation not supported on this platform.
        case unsupported
    }
}
