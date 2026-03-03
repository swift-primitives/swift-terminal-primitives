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

// MARK: - Key Type Tests

@Suite("Terminal.Input.Key")
struct KeyTests {

    @Test("Key equality with same code and modifiers")
    func keyEquality() {
        let key1 = Key(code: .character("a"), modifiers: .control)
        let key2 = Key(code: .character("a"), modifiers: .control)
        #expect(key1 == key2)
    }

    @Test("Key inequality with different modifiers")
    func keyInequalityModifiers() {
        let key1 = Key(code: .character("a"), modifiers: .control)
        let key2 = Key(code: .character("a"), modifiers: .alt)
        #expect(key1 != key2)
    }

    @Test("Key inequality with different codes")
    func keyInequalityCodes() {
        let key1 = Key(code: .character("a"))
        let key2 = Key(code: .character("b"))
        #expect(key1 != key2)
    }

    @Test("Default modifiers are empty")
    func defaultModifiers() {
        let key = Key(code: .enter)
        #expect(key.modifiers == [])
        #expect(key.text == nil)
        #expect(key.kind == nil)
    }
}

// MARK: - Modifiers OptionSet Tests

@Suite("Terminal.Input.Key.Modifiers")
struct ModifiersTests {

    @Test("Single modifier flags")
    func singleFlags() {
        #expect(Key.Modifiers.shift.rawValue == 1)
        #expect(Key.Modifiers.alt.rawValue == 2)
        #expect(Key.Modifiers.control.rawValue == 4)
        #expect(Key.Modifiers.super.rawValue == 8)
        #expect(Key.Modifiers.hyper.rawValue == 16)
        #expect(Key.Modifiers.meta.rawValue == 32)
        #expect(Key.Modifiers.capsLock.rawValue == 64)
        #expect(Key.Modifiers.numLock.rawValue == 128)
    }

    @Test("Modifier combination")
    func combination() {
        let mods: Key.Modifiers = [.shift, .control]
        #expect(mods.contains(.shift))
        #expect(mods.contains(.control))
        #expect(!mods.contains(.alt))
        #expect(mods.rawValue == 5)
    }

    @Test("Empty modifiers")
    func empty() {
        let mods = Key.Modifiers()
        #expect(mods.isEmpty)
        #expect(mods.rawValue == 0)
    }

    @Test("Modifiers are hashable")
    func hashable() {
        let a: Key.Modifiers = [.shift, .control]
        let b: Key.Modifiers = [.shift, .control]
        #expect(a.hashValue == b.hashValue)
    }

    @Test("CSI modifier encoding: value = 1 + bits")
    func csiEncoding() {
        // Shift: CSI param = 2 (1 + 1)
        // Alt: CSI param = 3 (1 + 2)
        // Ctrl: CSI param = 5 (1 + 4)
        // Shift+Ctrl: CSI param = 6 (1 + 5)
        #expect(Key.Modifiers(rawValue: UInt8(2 - 1)) == .shift)
        #expect(Key.Modifiers(rawValue: UInt8(3 - 1)) == .alt)
        #expect(Key.Modifiers(rawValue: UInt8(5 - 1)) == .control)
        #expect(Key.Modifiers(rawValue: UInt8(6 - 1)) == [.shift, .control])
    }
}

// MARK: - Mouse Type Tests

@Suite("Terminal.Input.Mouse")
struct MouseTypeTests {

    @Test("Mouse equality")
    func mouseEquality() {
        let m1 = Mouse(kind: .press(.left), column: 10, row: 20)
        let m2 = Mouse(kind: .press(.left), column: 10, row: 20)
        #expect(m1 == m2)
    }

    @Test("Mouse inequality different position")
    func mouseInequalityPosition() {
        let m1 = Mouse(kind: .press(.left), column: 10, row: 20)
        let m2 = Mouse(kind: .press(.left), column: 11, row: 20)
        #expect(m1 != m2)
    }

    @Test("Mouse inequality different button")
    func mouseInequalityButton() {
        let m1 = Mouse(kind: .press(.left), column: 10, row: 20)
        let m2 = Mouse(kind: .press(.right), column: 10, row: 20)
        #expect(m1 != m2)
    }

    @Test("Default mouse modifiers are empty")
    func defaultModifiers() {
        let mouse = Mouse(kind: .press(.left), column: 1, row: 1)
        #expect(mouse.modifiers == [])
    }
}

// MARK: - Event Type Tests

@Suite("Terminal.Input.Event")
struct EventTypeTests {

    @Test("Event equality for key events")
    func keyEquality() {
        let e1: Event = .key(Key(code: .enter))
        let e2: Event = .key(Key(code: .enter))
        #expect(e1 == e2)
    }

    @Test("Event inequality between key and mouse")
    func keyMouseInequality() {
        let key: Event = .key(Key(code: .enter))
        let mouse: Event = .mouse(Mouse(kind: .press(.left), column: 1, row: 1))
        #expect(key != mouse)
    }

    @Test("Resize event equality")
    func resizeEquality() {
        let e1: Event = .resize(Terminal.Size(rows: 24, columns: 80))
        let e2: Event = .resize(Terminal.Size(rows: 24, columns: 80))
        #expect(e1 == e2)
    }

    @Test("Paste event equality")
    func pasteEquality() {
        let e1: Event = .paste("hello")
        let e2: Event = .paste("hello")
        #expect(e1 == e2)
    }
}
