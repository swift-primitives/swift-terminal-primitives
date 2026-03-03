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

// MARK: - UTF-8 Multibyte Parsing

extension Terminal.Input.Parser {

    /// Parses a UTF-8 multibyte character sequence.
    ///
    /// The first byte (0x80–0xFF) has already been peeked but not consumed.
    /// Determines the expected length from the leading byte, then reads
    /// and validates continuation bytes (0x80–0xBF).
    ///
    /// - Throws: ``Error/invalidUTF8`` if the byte sequence is malformed.
    /// - Throws: ``Error/incompleteSequence`` if continuation bytes are missing.
    static func parseUTF8<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) throws(Error) -> Terminal.Input.Event
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        let first = consumeUnchecked(&input)

        let length: Int
        let initial: UInt32

        switch first {
        case 0xC0...0xDF:
            length = 2
            initial = UInt32(first & 0x1F)
        case 0xE0...0xEF:
            length = 3
            initial = UInt32(first & 0x0F)
        case 0xF0...0xF7:
            length = 4
            initial = UInt32(first & 0x07)
        default:
            throw .invalidUTF8
        }

        var codepoint = initial
        for _ in 1..<length {
            guard let byte = input.first else {
                throw .incompleteSequence
            }
            guard byte & 0xC0 == 0x80 else {
                throw .invalidUTF8
            }
            consumeUnchecked(&input)
            codepoint = (codepoint << 6) | UInt32(byte & 0x3F)
        }

        guard let scalar = Unicode.Scalar(codepoint) else {
            throw .invalidUTF8
        }

        return .key(Terminal.Input.Key(code: .character(scalar)))
    }
}
