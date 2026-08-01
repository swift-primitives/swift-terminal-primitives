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
    public enum Mouse {}
}
