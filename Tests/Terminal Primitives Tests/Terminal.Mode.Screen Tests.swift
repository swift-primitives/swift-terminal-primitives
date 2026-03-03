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

extension Terminal.Mode.Screen {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
    }
}

// MARK: - Unit

extension Terminal.Mode.Screen.Test.Unit {
    @Test
    func `Enable is DEC private mode 1049h`() {
        #expect(Terminal.Mode.Screen.enable == "\u{1B}[?1049h")
    }

    @Test
    func `Disable is DEC private mode 1049l`() {
        #expect(Terminal.Mode.Screen.disable == "\u{1B}[?1049l")
    }
}

// MARK: - EdgeCase

extension Terminal.Mode.Screen.Test.EdgeCase {
    @Test
    func `Enable and disable differ only in final byte`() {
        #expect(Terminal.Mode.Screen.enable.dropLast() == Terminal.Mode.Screen.disable.dropLast())
    }

    @Test
    func `Sequences use CSI private mode prefix`() {
        #expect(Terminal.Mode.Screen.enable.hasPrefix("\u{1B}[?"))
        #expect(Terminal.Mode.Screen.disable.hasPrefix("\u{1B}[?"))
    }
}
