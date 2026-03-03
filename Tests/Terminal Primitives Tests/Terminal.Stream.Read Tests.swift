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

extension Terminal.Stream.Read {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
    }
}

// MARK: - Unit

extension Terminal.Stream.Read.Test.Unit {
    @Test
    func `Init stores stream`() {
        let read = Terminal.Stream.Read(stream: .stdin)
        #expect(read.stream == .stdin)
    }

    @Test
    func `Accessor returns Read for stdin`() {
        let read = Terminal.Stream.stdin.read
        #expect(read.stream == .stdin)
    }

    @Test
    func `Accessor returns Read for stdout`() {
        let read = Terminal.Stream.stdout.read
        #expect(read.stream == .stdout)
    }

    @Test
    func `Accessor returns Read for stderr`() {
        let read = Terminal.Stream.stderr.read
        #expect(read.stream == .stderr)
    }
}

// MARK: - EdgeCase

extension Terminal.Stream.Read.Test.EdgeCase {
    @Test
    func `Each stream produces distinct Read accessor`() {
        let stdinRead = Terminal.Stream.stdin.read
        let stdoutRead = Terminal.Stream.stdout.read
        let stderrRead = Terminal.Stream.stderr.read

        #expect(stdinRead.stream != stdoutRead.stream)
        #expect(stdoutRead.stream != stderrRead.stream)
        #expect(stdinRead.stream != stderrRead.stream)
    }
}
