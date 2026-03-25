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

/// VT terminal input parser.
///
/// Parses raw byte sequences from a terminal into structured ``Terminal.Input.Event``
/// values. Supports standard VT/xterm sequences, SGR mouse encoding, and the
/// Kitty keyboard protocol.
///
/// The parser is stateless—all state lives in the ``Input.Buffer`` cursor.
/// Incomplete sequences restore the buffer position so the I/O layer can
/// retry after receiving more data.
///
/// ## Example
///
/// ```swift
/// var buffer = Input.Buffer<ContiguousArray<UInt8>>([0x1B, 0x5B, 0x41])
/// let event = try Terminal.Input.Parser.parse(&buffer)
/// // event == .key(Key(code: .up))
/// ```
extension Terminal.Input {
    public struct Parser: Sendable {
        public init() {}
    }
}

// MARK: - Main Dispatch

extension Terminal.Input.Parser {

    /// Parses the next input event from the buffer.
    ///
    /// Dispatches on the first byte:
    /// - ESC (0x1B) → escape sequence (CSI, SS3, or Alt+key)
    /// - DEL (0x7F) → backspace
    /// - Control characters (0x00–0x1A) → control key mapping
    /// - Printable ASCII (0x20–0x7E) → character key
    /// - High bytes (0x80–0xFF) → UTF-8 multibyte sequence
    ///
    /// - Parameter input: The byte buffer to parse from.
    /// - Returns: The parsed input event.
    /// - Throws: ``Error/emptyInput`` if the buffer is empty,
    ///   ``Error/incompleteSequence`` if more bytes are needed (buffer restored),
    ///   ``Error/unrecognizedSequence`` or ``Error/invalidUTF8`` for bad data.
    public static func parse<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) throws(Error) -> Terminal.Input.Event
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        guard let byte = input.first else {
            throw .emptyInput
        }

        switch byte {
        case ASCII.Byte.esc:
            let saved = input.checkpoint
            do {
                return try parseEscapeSequence(&input)
            } catch {
                if error == .incompleteSequence {
                    input.setPosition(to: saved)
                }
                throw error
            }

        case ASCII.Byte.del:
            consumeUnchecked(&input)
            return .key(Terminal.Input.Key(code: .backspace))

        case ASCII.Byte.nul...ASCII.Byte.us:
            return parseControlCharacter(&input)

        case ASCII.Byte.space...ASCII.Byte.tilde:
            let b = consumeUnchecked(&input)
            return .key(Terminal.Input.Key(code: .character(Unicode.Scalar(b))))

        default:
            let saved = input.checkpoint
            do {
                return try parseUTF8(&input)
            } catch {
                if error == .incompleteSequence {
                    input.setPosition(to: saved)
                }
                throw error
            }
        }
    }
}

// MARK: - Escape Sequence Dispatch

extension Terminal.Input.Parser {

    /// Parses an escape sequence after the initial ESC byte.
    ///
    /// Dispatches on the byte following ESC:
    /// - `[` → CSI sequence
    /// - `O` → SS3 sequence (F1–F4)
    /// - Printable → Alt+character
    static func parseEscapeSequence<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) throws(Error) -> Terminal.Input.Event
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        // Consume ESC
        consumeUnchecked(&input)

        guard let next = input.first else {
            throw .incompleteSequence
        }

        switch next {
        case ASCII.Byte.leftBracket:
            consumeUnchecked(&input)
            return try parseCSI(&input)

        case ASCII.Byte.O:
            consumeUnchecked(&input)
            return try parseSS3(&input)

        case ASCII.Byte.space...ASCII.Byte.tilde:
            consumeUnchecked(&input)
            return .key(Terminal.Input.Key(
                code: .character(Unicode.Scalar(next)),
                modifiers: .alt
            ))

        default:
            throw .unrecognizedSequence
        }
    }
}

// MARK: - Byte Consumption Helpers

extension Terminal.Input.Parser {

    /// Consumes one byte, converting stream exhaustion to `.incompleteSequence`.
    @inline(always)
    static func consume<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) throws(Error) -> UInt8
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        do {
            return try input.advance()
        } catch {
            throw .incompleteSequence
        }
    }

    /// Consumes one byte without checking. Caller guarantees `!input.isEmpty`.
    @inline(always)
    @discardableResult
    static func consumeUnchecked<Storage>(
        _ input: inout Input.Buffer<Storage>
    ) -> UInt8
    where Storage: RandomAccessCollection & Sendable,
          Storage.Element == UInt8,
          Storage.Index: Sendable & Hashable
    {
        try! input.advance()
    }
}
