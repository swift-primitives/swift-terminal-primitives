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

// MARK: - Kitty Keyboard Protocol Parsing

extension Terminal.Input.Parser {

    /// Parses a Kitty keyboard protocol event from collected CSI parameters.
    ///
    /// Kitty format: `ESC [ <codepoint> ; <modifiers> u`
    /// Extended: `ESC [ <codepoint> ; <modifiers>:<event_type> u`
    ///
    /// The codepoint is a Unicode code point. Special keys use codepoints
    /// in the private use area (U+E000–U+E07F).
    static func parseKittyKeyboard(
        codepoint: UInt32,
        modifierParam: UInt32,
        eventType: UInt32,
        hasEventType: Bool
    ) throws(Error) -> Terminal.Input.Event {
        let modifiers = modifiersFromCSI(modifierParam)

        let kind: Terminal.Input.Key.Kind? = if hasEventType {
            switch eventType {
            case 1: .press
            case 2: .repeat
            case 3: .release
            default: nil
            }
        } else {
            nil
        }

        let code = mapCodepointToKeyCode(codepoint)

        // Text representation for printable codepoints
        let text: Swift.String?
        if let scalar = Unicode.Scalar(codepoint),
           codepoint >= 0x20 && codepoint != 0x7F && codepoint < 0xE000
        {
            text = Swift.String(scalar)
        } else {
            text = nil
        }

        return .key(Terminal.Input.Key(code: code, modifiers: modifiers, text: text, kind: kind))
    }

    /// Maps a Unicode codepoint to a key code.
    ///
    /// Standard control codepoints map to their conventional key names.
    /// Kitty functional keys (U+E000–U+E07F) map to `.kitty(...)`.
    /// Everything else maps to `.character(...)`.
    private static func mapCodepointToKeyCode(_ codepoint: UInt32) -> Terminal.Input.Key.Code {
        switch codepoint {
        case 9: .tab
        case 13: .enter
        case 27: .escape
        case 127: .backspace
        case 57344...57503: .kitty(codepoint)
        default:
            if let scalar = Unicode.Scalar(codepoint) {
                .character(scalar)
            } else {
                .kitty(codepoint)
            }
        }
    }
}
