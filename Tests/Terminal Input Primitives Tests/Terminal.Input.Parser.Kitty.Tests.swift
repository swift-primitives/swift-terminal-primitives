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

// MARK: - Kitty Keyboard Protocol

@Suite("Parser — Kitty Keyboard")
struct KittyKeyboardTests {

    @Test("Ctrl+a: ESC [ 97 ; 5 u")
    func ctrlA() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x37, 0x3B, 0x35, 0x75])
        #expect(event == .key(Key(
            code: .character("a"),
            modifiers: .control,
            text: "a"
        )))
    }

    @Test("Simple 'a' key: ESC [ 97 u")
    func simpleA() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x37, 0x75])
        #expect(event == .key(Key(
            code: .character("a"),
            text: "a"
        )))
    }

    @Test("Enter in Kitty: ESC [ 13 u")
    func kittyEnter() throws {
        // 13 = 0x31 0x33
        let event = try parse([0x1B, 0x5B, 0x31, 0x33, 0x75])
        #expect(event == .key(Key(code: .enter)))
    }

    @Test("Tab in Kitty: ESC [ 9 u")
    func kittyTab() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x75])
        #expect(event == .key(Key(code: .tab)))
    }

    @Test("Escape in Kitty: ESC [ 27 u")
    func kittyEscape() throws {
        // 27 = 0x32 0x37
        let event = try parse([0x1B, 0x5B, 0x32, 0x37, 0x75])
        #expect(event == .key(Key(code: .escape)))
    }

    @Test("Kitty key release: ESC [ 97 ; 1 : 3 u")
    func kittyRelease() throws {
        // 97;1:3u → codepoint 97 ('a'), modifiers 1 (none), event_type 3 (release)
        let event = try parse([
            0x1B, 0x5B,
            0x39, 0x37, 0x3B,       // 97 ;
            0x31, 0x3A,              // 1 :
            0x33,                    // 3
            0x75                     // u
        ])
        #expect(event == .key(Key(
            code: .character("a"),
            text: "a",
            kind: .release
        )))
    }

    @Test("Kitty key repeat: ESC [ 97 ; 1 : 2 u")
    func kittyRepeat() throws {
        let event = try parse([
            0x1B, 0x5B,
            0x39, 0x37, 0x3B,       // 97 ;
            0x31, 0x3A,             // 1 :
            0x32,                    // 2
            0x75                     // u
        ])
        #expect(event == .key(Key(
            code: .character("a"),
            text: "a",
            kind: .repeat
        )))
    }

    @Test("Kitty functional key (private use area)")
    func kittyFunctional() throws {
        // 57344 = 0xE000 (first Kitty functional key)
        // "57344" as ASCII bytes: 0x35 0x37 0x33 0x34 0x34
        let event = try parse([
            0x1B, 0x5B,
            0x35, 0x37, 0x33, 0x34, 0x34,  // 57344
            0x75                             // u
        ])
        #expect(event == .key(Key(code: .kitty(57344))))
    }

    @Test("Shift+a: ESC [ 97 ; 2 u")
    func shiftA() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x37, 0x3B, 0x32, 0x75])
        #expect(event == .key(Key(
            code: .character("a"),
            modifiers: .shift,
            text: "a"
        )))
    }
}
