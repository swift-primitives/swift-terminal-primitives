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

// MARK: - Control Character Parsing

extension Terminal.Input.Parser {

    /// Maps a control character byte to a key event.
    ///
    /// Standalone keys (Tab, Enter, Backspace) produce unmodified key events.
    /// Other control characters produce Ctrl+letter events:
    /// - 0x01–0x1A → Ctrl+a through Ctrl+z
    /// - 0x1C–0x1F → Ctrl+\ through Ctrl+_
    static func parseControlCharacter<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) -> Terminal.Input.Event
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        let byte = consumeUnchecked(&input)

        switch byte {
        case ASCII.Byte.cr:
            return .key(Terminal.Input.Key(code: .enter))

        case ASCII.Byte.tab:
            return .key(Terminal.Input.Key(code: .tab))

        case ASCII.Byte.bs:
            return .key(Terminal.Input.Key(code: .backspace))

        case ASCII.Byte.nul:
            return .key(Terminal.Input.Key(
                code: .character(Unicode.Scalar(ASCII.Byte.space)),
                modifiers: .control
            ))

        default:
            if byte <= ASCII.Byte.sub {
                // 0x01–0x1A → Ctrl+a through Ctrl+z (lowercase)
                return .key(Terminal.Input.Key(
                    code: .character(Unicode.Scalar(byte &+ 0x60)),
                    modifiers: .control
                ))
            } else {
                // 0x1C–0x1F → Ctrl+\ through Ctrl+_
                return .key(Terminal.Input.Key(
                    code: .character(Unicode.Scalar(byte &+ 0x40)),
                    modifiers: .control
                ))
            }
        }
    }
}
