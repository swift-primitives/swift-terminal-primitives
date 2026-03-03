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
import Terminal_Primitives

extension Terminal.Mode.Keyboard {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
    }
}

// MARK: - Unit

extension Terminal.Mode.Keyboard.Test.Unit {
    @Test
    func `Enable pushes Kitty keyboard mode with flags 1`() {
        #expect(Terminal.Mode.Keyboard.enable == "\u{1B}[>1u")
    }

    @Test
    func `Disable pops Kitty keyboard mode`() {
        #expect(Terminal.Mode.Keyboard.disable == "\u{1B}[<u")
    }
}

// MARK: - EdgeCase

extension Terminal.Mode.Keyboard.Test.EdgeCase {
    @Test
    func `Sequences use CSI prefix without private mode marker`() {
        // Kitty uses CSI > and CSI < instead of CSI ?
        #expect(Terminal.Mode.Keyboard.enable.hasPrefix("\u{1B}[>"))
        #expect(Terminal.Mode.Keyboard.disable.hasPrefix("\u{1B}[<"))
    }

    @Test
    func `Both sequences end with u`() {
        #expect(Terminal.Mode.Keyboard.enable.hasSuffix("u"))
        #expect(Terminal.Mode.Keyboard.disable.hasSuffix("u"))
    }

    @Test
    func `Enable and disable are distinct`() {
        #expect(Terminal.Mode.Keyboard.enable != Terminal.Mode.Keyboard.disable)
    }
}
