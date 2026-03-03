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

/// Terminal input namespace.
///
/// Provides types for parsing and representing terminal input events
/// including keyboard, mouse, resize, and paste events.
///
/// ## Example
///
/// ```swift
/// var buffer = Input.Buffer<ContiguousArray<UInt8>>(bytes)
/// let event = try Terminal.Input.Parser.parse(&buffer)
/// switch event {
/// case .key(let key):
///     print("Key: \(key.code)")
/// case .mouse(let mouse):
///     print("Mouse at \(mouse.column), \(mouse.row)")
/// case .resize(let size):
///     print("Resized to \(size.columns)x\(size.rows)")
/// case .paste(let text):
///     print("Pasted: \(text)")
/// }
/// ```
extension Terminal {
    public enum Input {}
}
