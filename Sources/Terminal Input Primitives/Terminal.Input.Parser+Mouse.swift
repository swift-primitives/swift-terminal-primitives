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

// MARK: - SGR Mouse Parsing

extension Terminal.Input.Parser {

    /// Parses an SGR mouse event from collected CSI parameters.
    ///
    /// SGR format: `ESC [ < Pb ; Px ; Py M` (press) or `ESC [ < Pb ; Px ; Py m` (release)
    ///
    /// Button bits in Pb:
    /// - Low 2 bits: button number (0=left, 1=middle, 2=right)
    /// - Bit 2 (4): Shift
    /// - Bit 3 (8): Alt
    /// - Bit 4 (16): Control
    /// - Bit 5 (32): Motion flag (drag/move)
    /// - Bit 6 (64): Scroll base (64=up, 65=down, 66=left, 67=right)
    /// - Bit 7 (128): Extended buttons (128=backward, 129=forward)
    static func parseSGRMouse(
        buttonBits: UInt32,
        column: UInt32,
        row: UInt32,
        paramCount: Int,
        finalByte: UInt8
    ) throws(Error) -> Terminal.Input.Event {
        guard paramCount >= 3 else { throw .unrecognizedSequence }

        let isRelease = finalByte == ASCII.Byte.m
        let isMotion = buttonBits & 32 != 0

        // Extract modifier flags from button bits
        var modifiers = Terminal.Input.Key.Modifiers()
        if buttonBits & 4 != 0 { modifiers.insert(.shift) }
        if buttonBits & 8 != 0 { modifiers.insert(.alt) }
        if buttonBits & 16 != 0 { modifiers.insert(.control) }

        // Strip modifier and motion bits to get the button value
        let buttonValue = buttonBits & ~UInt32(4 | 8 | 16 | 32)

        let kind: Terminal.Input.Mouse.Kind
        switch buttonValue {
        case 0:
            kind = isRelease ? .release(.left) : (isMotion ? .drag(.left) : .press(.left))
        case 1:
            kind = isRelease ? .release(.middle) : (isMotion ? .drag(.middle) : .press(.middle))
        case 2:
            kind = isRelease ? .release(.right) : (isMotion ? .drag(.right) : .press(.right))
        case 3:
            kind = .move
        case 64:
            kind = .scrollUp
        case 65:
            kind = .scrollDown
        case 66:
            kind = .scrollLeft
        case 67:
            kind = .scrollRight
        case 128:
            kind = isRelease ? .release(.backward) : (isMotion ? .drag(.backward) : .press(.backward))
        case 129:
            kind = isRelease ? .release(.forward) : (isMotion ? .drag(.forward) : .press(.forward))
        default:
            throw .unrecognizedSequence
        }

        return .mouse(Terminal.Input.Mouse(
            kind: kind,
            column: UInt16(truncatingIfNeeded: column),
            row: UInt16(truncatingIfNeeded: row),
            modifiers: modifiers
        ))
    }
}
