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

import Testing
import Terminal_Input_Primitives

typealias Key = Terminal.Input.Key
typealias Mouse = Terminal.Input.Mouse
typealias Event = Terminal.Input.Event
typealias Parser = Terminal.Input.Parser
typealias ParseError = Terminal.Input.Parser.Error

/// Helper: parse a single event from a byte array.
func parse(_ bytes: [UInt8]) throws(ParseError) -> Event {
    var buffer = Input.Buffer<ContiguousArray<UInt8>>(ContiguousArray(bytes))
    return try Parser.parse(&buffer)
}

// MARK: - Single Byte Tests

@Suite("Parser — Single Bytes")
struct SingleByteTests {

    @Test
    func `Printable ASCII characters`() throws {
        let event = try parse([0x61])
        #expect(event == .key(Key(code: .character("a"))))
    }

    @Test
    func `Space character`() throws {
        let event = try parse([0x20])
        #expect(event == .key(Key(code: .character(" "))))
    }

    @Test
    func `Tilde character`() throws {
        let event = try parse([0x7E])
        #expect(event == .key(Key(code: .character("~"))))
    }

    @Test
    func `DEL produces backspace`() throws {
        let event = try parse([0x7F])
        #expect(event == .key(Key(code: .backspace)))
    }

    @Test
    func `Empty input throws emptyInput`() {
        #expect(throws: ParseError.emptyInput) {
            try parse([])
        }
    }
}

// MARK: - Control Character Tests

@Suite("Parser — Control Characters")
struct ControlCharacterTests {

    @Test
    func `Enter (CR)`() throws {
        let event = try parse([0x0D])
        #expect(event == .key(Key(code: .enter)))
    }

    @Test
    func `Tab`() throws {
        let event = try parse([0x09])
        #expect(event == .key(Key(code: .tab)))
    }

    @Test
    func `Backspace (BS)`() throws {
        let event = try parse([0x08])
        #expect(event == .key(Key(code: .backspace)))
    }

    @Test
    func `Ctrl+A`() throws {
        let event = try parse([0x01])
        #expect(event == .key(Key(code: .character("a"), modifiers: .control)))
    }

    @Test
    func `Ctrl+C`() throws {
        let event = try parse([0x03])
        #expect(event == .key(Key(code: .character("c"), modifiers: .control)))
    }

    @Test
    func `Ctrl+Z`() throws {
        let event = try parse([0x1A])
        #expect(event == .key(Key(code: .character("z"), modifiers: .control)))
    }

    @Test
    func `Ctrl+Space (NUL)`() throws {
        let event = try parse([0x00])
        #expect(event == .key(Key(code: .character(" "), modifiers: .control)))
    }

    @Test
    func `Ctrl+Backslash (FS)`() throws {
        let event = try parse([0x1C])
        #expect(event == .key(Key(code: .character("\\"), modifiers: .control)))
    }
}

// MARK: - Escape Tests

@Suite("Parser — Escape Sequences")
struct EscapeTests {

    @Test
    func `Bare ESC throws incompleteSequence`() {
        #expect(throws: ParseError.incompleteSequence) {
            try parse([0x1B])
        }
    }

    @Test
    func `Bare ESC restores buffer position`() {
        var buffer = Input.Buffer<ContiguousArray<UInt8>>(ContiguousArray<UInt8>([0x1B]))
        let saved = buffer.checkpoint
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer.checkpoint == saved)
    }

    @Test
    func `Alt+a`() throws {
        let event = try parse([0x1B, 0x61])
        #expect(event == .key(Key(code: .character("a"), modifiers: .alt)))
    }

    @Test
    func `Alt+Z`() throws {
        let event = try parse([0x1B, 0x5A])
        #expect(event == .key(Key(code: .character("Z"), modifiers: .alt)))
    }
}

// MARK: - UTF-8 Tests

@Suite("Parser — UTF-8")
struct UTF8Tests {

    @Test
    func `2-byte UTF-8 (é)`() throws {
        // U+00E9 LATIN SMALL LETTER E WITH ACUTE = 0xC3 0xA9
        let event = try parse([0xC3, 0xA9])
        #expect(event == .key(Key(code: .character("\u{00E9}"))))
    }

    @Test
    func `3-byte UTF-8 (€)`() throws {
        // U+20AC EURO SIGN = 0xE2 0x82 0xAC
        let event = try parse([0xE2, 0x82, 0xAC])
        #expect(event == .key(Key(code: .character("\u{20AC}"))))
    }

    @Test
    func `4-byte UTF-8 (😀)`() throws {
        // U+1F600 GRINNING FACE = 0xF0 0x9F 0x98 0x80
        let event = try parse([0xF0, 0x9F, 0x98, 0x80])
        #expect(event == .key(Key(code: .character("\u{1F600}"))))
    }

    @Test
    func `Incomplete UTF-8 throws incompleteSequence`() {
        // 2-byte start with no continuation
        #expect(throws: ParseError.incompleteSequence) {
            try parse([0xC3])
        }
    }

    @Test
    func `Invalid continuation byte throws invalidUTF8`() {
        // 2-byte start with invalid continuation (not 0x80-0xBF)
        #expect(throws: ParseError.invalidUTF8) {
            try parse([0xC3, 0x41])
        }
    }

    @Test
    func `Incomplete UTF-8 restores buffer position`() {
        var buffer = Input.Buffer<ContiguousArray<UInt8>>(ContiguousArray<UInt8>([0xC3]))
        let saved = buffer.checkpoint
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer.checkpoint == saved)
    }
}

// MARK: - Sequential Parsing Tests

@Suite("Parser — Sequential Events")
struct SequentialTests {

    @Test
    func `Parse multiple events from one buffer`() throws {
        // "ab" = two character events
        var buffer = Input.Buffer<ContiguousArray<UInt8>>(ContiguousArray<UInt8>([0x61, 0x62]))
        let first = try Parser.parse(&buffer)
        let second = try Parser.parse(&buffer)
        #expect(first == .key(Key(code: .character("a"))))
        #expect(second == .key(Key(code: .character("b"))))
    }

    @Test
    func `Buffer is empty after consuming all bytes`() throws {
        var buffer = Input.Buffer<ContiguousArray<UInt8>>(ContiguousArray<UInt8>([0x61]))
        _ = try Parser.parse(&buffer)
        let empty = buffer.isEmpty
        #expect(empty)
    }
}
