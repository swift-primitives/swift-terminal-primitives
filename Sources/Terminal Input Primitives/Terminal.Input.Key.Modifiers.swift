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

/// Keyboard modifier flags.
///
/// Bit layout matches the CSI modifier encoding used by xterm and
/// the Kitty keyboard protocol: `encoded_value = 1 + modifier_bits`.
///
/// - Bit 0: Shift
/// - Bit 1: Alt
/// - Bit 2: Control
/// - Bit 3: Super
/// - Bit 4: Hyper
/// - Bit 5: Meta
/// - Bit 6: Caps Lock
/// - Bit 7: Num Lock
extension Terminal.Input.Key {
    public struct Modifiers: OptionSet, Sendable, Equatable, Hashable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let shift    = Modifiers(rawValue: 1 << 0)
        public static let alt      = Modifiers(rawValue: 1 << 1)
        public static let control  = Modifiers(rawValue: 1 << 2)
        public static let `super`  = Modifiers(rawValue: 1 << 3)
        public static let hyper    = Modifiers(rawValue: 1 << 4)
        public static let meta     = Modifiers(rawValue: 1 << 5)
        public static let capsLock = Modifiers(rawValue: 1 << 6)
        public static let numLock  = Modifiers(rawValue: 1 << 7)
    }
}
