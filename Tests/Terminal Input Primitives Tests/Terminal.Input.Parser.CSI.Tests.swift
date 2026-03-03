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

// MARK: - Arrow Keys

@Suite("Parser — CSI Arrow Keys")
struct CSIArrowTests {

    @Test("Arrow up: ESC [ A")
    func arrowUp() throws {
        let event = try parse([0x1B, 0x5B, 0x41])
        #expect(event == .key(Key(code: .up)))
    }

    @Test("Arrow down: ESC [ B")
    func arrowDown() throws {
        let event = try parse([0x1B, 0x5B, 0x42])
        #expect(event == .key(Key(code: .down)))
    }

    @Test("Arrow right: ESC [ C")
    func arrowRight() throws {
        let event = try parse([0x1B, 0x5B, 0x43])
        #expect(event == .key(Key(code: .right)))
    }

    @Test("Arrow left: ESC [ D")
    func arrowLeft() throws {
        let event = try parse([0x1B, 0x5B, 0x44])
        #expect(event == .key(Key(code: .left)))
    }
}

// MARK: - Modified Arrow Keys

@Suite("Parser — CSI Modified Keys")
struct CSIModifiedKeyTests {

    @Test("Ctrl+Up: ESC [ 1 ; 5 A")
    func ctrlUp() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x35, 0x41])
        #expect(event == .key(Key(code: .up, modifiers: .control)))
    }

    @Test("Shift+Right: ESC [ 1 ; 2 C")
    func shiftRight() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x32, 0x43])
        #expect(event == .key(Key(code: .right, modifiers: .shift)))
    }

    @Test("Alt+Down: ESC [ 1 ; 3 B")
    func altDown() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x33, 0x42])
        #expect(event == .key(Key(code: .down, modifiers: .alt)))
    }

    @Test("Ctrl+Shift+Left: ESC [ 1 ; 6 D")
    func ctrlShiftLeft() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x36, 0x44])
        #expect(event == .key(Key(code: .left, modifiers: [.shift, .control])))
    }
}

// MARK: - Navigation Keys

@Suite("Parser — CSI Navigation Keys")
struct CSINavigationTests {

    @Test("Home: ESC [ H")
    func home() throws {
        let event = try parse([0x1B, 0x5B, 0x48])
        #expect(event == .key(Key(code: .home)))
    }

    @Test("End: ESC [ F")
    func end() throws {
        let event = try parse([0x1B, 0x5B, 0x46])
        #expect(event == .key(Key(code: .end)))
    }

    @Test("Backtab: ESC [ Z")
    func backtab() throws {
        let event = try parse([0x1B, 0x5B, 0x5A])
        #expect(event == .key(Key(code: .backtab)))
    }
}

// MARK: - Tilde Keys

@Suite("Parser — CSI Tilde Keys")
struct CSITildeTests {

    @Test("Insert: ESC [ 2 ~")
    func insert() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x7E])
        #expect(event == .key(Key(code: .insert)))
    }

    @Test("Delete: ESC [ 3 ~")
    func delete() throws {
        let event = try parse([0x1B, 0x5B, 0x33, 0x7E])
        #expect(event == .key(Key(code: .delete)))
    }

    @Test("Page Up: ESC [ 5 ~")
    func pageUp() throws {
        let event = try parse([0x1B, 0x5B, 0x35, 0x7E])
        #expect(event == .key(Key(code: .pageUp)))
    }

    @Test("Page Down: ESC [ 6 ~")
    func pageDown() throws {
        let event = try parse([0x1B, 0x5B, 0x36, 0x7E])
        #expect(event == .key(Key(code: .pageDown)))
    }

    @Test("Home (tilde): ESC [ 1 ~")
    func homeTilde() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x7E])
        #expect(event == .key(Key(code: .home)))
    }

    @Test("End (tilde): ESC [ 4 ~")
    func endTilde() throws {
        let event = try parse([0x1B, 0x5B, 0x34, 0x7E])
        #expect(event == .key(Key(code: .end)))
    }
}

// MARK: - Function Keys

@Suite("Parser — CSI Function Keys")
struct CSIFunctionKeyTests {

    @Test("F5: ESC [ 15 ~")
    func f5() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x35, 0x7E])
        #expect(event == .key(Key(code: .function(5))))
    }

    @Test("F6: ESC [ 17 ~")
    func f6() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x37, 0x7E])
        #expect(event == .key(Key(code: .function(6))))
    }

    @Test("F10: ESC [ 21 ~")
    func f10() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x31, 0x7E])
        #expect(event == .key(Key(code: .function(10))))
    }

    @Test("F12: ESC [ 24 ~")
    func f12() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x34, 0x7E])
        #expect(event == .key(Key(code: .function(12))))
    }

    @Test("Ctrl+F5: ESC [ 15 ; 5 ~")
    func ctrlF5() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x35, 0x3B, 0x35, 0x7E])
        #expect(event == .key(Key(code: .function(5), modifiers: .control)))
    }
}

// MARK: - SS3 Function Keys

@Suite("Parser — SS3 Function Keys")
struct SS3Tests {

    @Test("F1: ESC O P")
    func f1() throws {
        let event = try parse([0x1B, 0x4F, 0x50])
        #expect(event == .key(Key(code: .function(1))))
    }

    @Test("F2: ESC O Q")
    func f2() throws {
        let event = try parse([0x1B, 0x4F, 0x51])
        #expect(event == .key(Key(code: .function(2))))
    }

    @Test("F3: ESC O R")
    func f3() throws {
        let event = try parse([0x1B, 0x4F, 0x52])
        #expect(event == .key(Key(code: .function(3))))
    }

    @Test("F4: ESC O S")
    func f4() throws {
        let event = try parse([0x1B, 0x4F, 0x53])
        #expect(event == .key(Key(code: .function(4))))
    }

    @Test("Home (SS3): ESC O H")
    func homeSS3() throws {
        let event = try parse([0x1B, 0x4F, 0x48])
        #expect(event == .key(Key(code: .home)))
    }

    @Test("End (SS3): ESC O F")
    func endSS3() throws {
        let event = try parse([0x1B, 0x4F, 0x46])
        #expect(event == .key(Key(code: .end)))
    }
}

// MARK: - Bracketed Paste

@Suite("Parser — Bracketed Paste")
struct BracketedPasteTests {

    @Test("Paste start: ESC [ 200 ~")
    func pasteStart() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7E])
        #expect(event == .paste(""))
    }
}

// MARK: - Incomplete CSI

@Suite("Parser — Incomplete Sequences")
struct IncompleteCSITests {

    @Test("Incomplete CSI restores position: ESC [")
    func incompleteCSI() {
        var buffer = Input.Buffer<ContiguousArray<UInt8>>(ContiguousArray<UInt8>([0x1B, 0x5B]))
        let saved = buffer.checkpoint
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer.checkpoint == saved)
    }

    @Test("Incomplete arrow restores position: ESC [ 1 ;")
    func incompleteArrow() {
        var buffer = Input.Buffer<ContiguousArray<UInt8>>(
            ContiguousArray<UInt8>([0x1B, 0x5B, 0x31, 0x3B])
        )
        let saved = buffer.checkpoint
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer.checkpoint == saved)
    }
}
