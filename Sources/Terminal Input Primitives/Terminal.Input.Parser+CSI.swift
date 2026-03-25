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

// MARK: - CSI Sequence Parsing

extension Terminal.Input.Parser {

    /// Parses a CSI sequence. ESC [ has already been consumed.
    ///
    /// CSI format: `ESC [ <params> <final>`
    /// - Parameters are `;`-separated decimal numbers
    /// - `<` prefix indicates SGR mouse encoding
    /// - Final byte (0x40–0x7E) determines the sequence type
    static func parseCSI<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) throws(Error) -> Terminal.Input.Event
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        // Check for SGR mouse prefix
        var isSGRMouse = false
        if input.first == ASCII.Byte.lessThan {
            isSGRMouse = true
            consumeUnchecked(&input)
        }

        // Collect numeric parameters
        var p0: UInt32 = 0, p1: UInt32 = 0, p2: UInt32 = 0
        var paramCount: Int = 0
        var eventType: UInt32 = 0
        var hasEventType = false

        collectParameters(
            from: &input,
            p0: &p0, p1: &p1, p2: &p2,
            count: &paramCount,
            eventType: &eventType,
            hasEventType: &hasEventType
        )

        // Read final byte
        let finalByte = try consume(&input)

        // SGR mouse dispatch
        if isSGRMouse {
            return try parseSGRMouse(
                buttonBits: p0,
                column: p1,
                row: p2,
                paramCount: paramCount,
                finalByte: finalByte
            )
        }

        // CSI final byte dispatch
        switch finalByte {
        case ASCII.Byte.A:
            return .key(Terminal.Input.Key(code: .up, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)))
        case ASCII.Byte.B:
            return .key(Terminal.Input.Key(code: .down, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)))
        case ASCII.Byte.C:
            return .key(Terminal.Input.Key(code: .right, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)))
        case ASCII.Byte.D:
            return .key(Terminal.Input.Key(code: .left, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)))
        case ASCII.Byte.H:
            return .key(Terminal.Input.Key(code: .home, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)))
        case ASCII.Byte.F:
            return .key(Terminal.Input.Key(code: .end, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)))
        case ASCII.Byte.Z:
            return .key(Terminal.Input.Key(code: .backtab))
        case ASCII.Byte.tilde:
            return try parseTildeKey(
                keyNumber: p0,
                modifierParam: paramCount >= 2 ? p1 : 0,
                paramCount: paramCount
            )
        case ASCII.Byte.u:
            return try parseKittyKeyboard(
                codepoint: p0,
                modifierParam: paramCount >= 2 ? p1 : 0,
                eventType: eventType,
                hasEventType: hasEventType
            )
        default:
            throw .unrecognizedSequence
        }
    }
}

// MARK: - Parameter Collection

extension Terminal.Input.Parser {

    /// Collects CSI numeric parameters from the input buffer.
    ///
    /// Parameters are `;`-separated decimal numbers. A `:` separator
    /// indicates Kitty keyboard sub-parameters (event type).
    static func collectParameters<Storage>(
        from input: inout Input.Buffer<Storage>,
        p0: inout UInt32,
        p1: inout UInt32,
        p2: inout UInt32,
        count: inout Int,
        eventType: inout UInt32,
        hasEventType: inout Bool
    )
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        var current: UInt32 = 0
        var needsPush = false

        while let byte = input.first {
            if byte >= ASCII.Byte.`0` && byte <= ASCII.Byte.`9` {
                current = current &* 10 &+ UInt32(byte &- ASCII.Byte.`0`)
                needsPush = true
                consumeUnchecked(&input)
            } else if byte == ASCII.Byte.semicolon {
                pushParam(current, p0: &p0, p1: &p1, p2: &p2, count: &count)
                current = 0
                needsPush = true
                consumeUnchecked(&input)
            } else if byte == ASCII.Byte.colon {
                // Kitty sub-parameter: push current main param, then read sub-param
                pushParam(current, p0: &p0, p1: &p1, p2: &p2, count: &count)
                current = 0
                needsPush = false
                consumeUnchecked(&input)

                // Collect sub-parameter digits
                while let b = input.first, b >= ASCII.Byte.`0` && b <= ASCII.Byte.`9` {
                    current = current &* 10 &+ UInt32(b &- ASCII.Byte.`0`)
                    consumeUnchecked(&input)
                }
                eventType = current
                hasEventType = true
                current = 0
            } else {
                break
            }
        }

        if needsPush {
            pushParam(current, p0: &p0, p1: &p1, p2: &p2, count: &count)
        }
    }

    @inline(always)
    private static func pushParam(
        _ value: UInt32,
        p0: inout UInt32,
        p1: inout UInt32,
        p2: inout UInt32,
        count: inout Int
    ) {
        switch count {
        case 0: p0 = value
        case 1: p1 = value
        case 2: p2 = value
        default: break
        }
        count += 1
    }
}

// MARK: - Modifier Decoding

extension Terminal.Input.Parser {

    /// Decodes a CSI modifier parameter to modifier flags.
    ///
    /// CSI encoding: `encoded = 1 + modifier_bits`.
    /// A value of 0 or 1 means no modifiers.
    @inline(always)
    static func modifiersFromCSI(_ param: UInt32) -> Terminal.Input.Key.Modifiers {
        guard param > 1 else { return [] }
        return Terminal.Input.Key.Modifiers(rawValue: UInt8(truncatingIfNeeded: param &- 1))
    }
}

// MARK: - Tilde Key Dispatch

extension Terminal.Input.Parser {

    /// Dispatches a CSI tilde sequence by key number.
    ///
    /// Format: `ESC [ <number> ~` or `ESC [ <number> ; <modifier> ~`
    static func parseTildeKey(
        keyNumber: UInt32,
        modifierParam: UInt32,
        paramCount: Int
    ) throws(Error) -> Terminal.Input.Event {
        guard paramCount >= 1 else { throw .unrecognizedSequence }

        let modifiers = modifiersFromCSI(modifierParam)

        let code: Terminal.Input.Key.Code
        switch keyNumber {
        case 1: code = .home
        case 2: code = .insert
        case 3: code = .delete
        case 4: code = .end
        case 5: code = .pageUp
        case 6: code = .pageDown
        case 11: code = .function(1)
        case 12: code = .function(2)
        case 13: code = .function(3)
        case 14: code = .function(4)
        case 15: code = .function(5)
        case 17: code = .function(6)
        case 18: code = .function(7)
        case 19: code = .function(8)
        case 20: code = .function(9)
        case 21: code = .function(10)
        case 23: code = .function(11)
        case 24: code = .function(12)
        case 200:
            return .paste("")
        case 201:
            throw .unrecognizedSequence
        default:
            throw .unrecognizedSequence
        }

        return .key(Terminal.Input.Key(code: code, modifiers: modifiers))
    }
}

// MARK: - SS3 Dispatch

extension Terminal.Input.Parser {

    /// Parses an SS3 sequence. ESC O has already been consumed.
    ///
    /// SS3 sequences encode F1–F4 and Home/End in some terminal emulators.
    static func parseSS3<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) throws(Error) -> Terminal.Input.Event
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        let byte = try consume(&input)

        let code: Terminal.Input.Key.Code
        switch byte {
        case ASCII.Byte.P: code = .function(1)
        case ASCII.Byte.Q: code = .function(2)
        case ASCII.Byte.R: code = .function(3)
        case ASCII.Byte.S: code = .function(4)
        case ASCII.Byte.H: code = .home
        case ASCII.Byte.F: code = .end
        default: throw .unrecognizedSequence
        }

        return .key(Terminal.Input.Key(code: code))
    }
}
