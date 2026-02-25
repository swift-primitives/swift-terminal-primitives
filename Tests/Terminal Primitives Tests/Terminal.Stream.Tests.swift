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
@testable import Terminal_Primitives

@Suite("Terminal.Stream Tests")
struct StreamTests {
    @Test("Stream raw values are correct")
    func streamRawValues() {
        #expect(Terminal.Stream.stdin.rawValue == 0)
        #expect(Terminal.Stream.stdout.rawValue == 1)
        #expect(Terminal.Stream.stderr.rawValue == 2)
    }

    @Test("All streams can be iterated")
    func streamIteration() {
        let streams = Terminal.Stream.allCases
        #expect(streams.count == 3)
        #expect(streams.contains(.stdin))
        #expect(streams.contains(.stdout))
        #expect(streams.contains(.stderr))
    }
}

@Suite("Terminal.Size Tests")
struct SizeTests {
    @Test("Size can be created")
    func sizeCreation() {
        let size = Terminal.Size(rows: 24, columns: 80)
        #expect(size.rows == 24)
        #expect(size.columns == 80)
    }

    @Test("Size is hashable")
    func sizeHashable() {
        let size1 = Terminal.Size(rows: 24, columns: 80)
        let size2 = Terminal.Size(rows: 24, columns: 80)
        let size3 = Terminal.Size(rows: 25, columns: 80)
        #expect(size1 == size2)
        #expect(size1 != size3)
    }
}
