// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-terminal-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-terminal-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Terminal_Primitives
import Testing

extension Terminal.Stream.Write {
    @Suite
    struct Test {
        @Suite struct Unit {}
    }
}

extension Terminal.Stream.Write.Test.Unit {
    @Test
    func `write accessor preserves stream identity`() {
        let stream = Terminal.Stream.stdout
        let write = stream.write
        #expect(write.stream == .stdout)
    }

    @Test
    func `write accessor available for stderr`() {
        let stream = Terminal.Stream.stderr
        let write = stream.write
        #expect(write.stream == .stderr)
    }

    @Test
    func `write accessor available for stdin (FD only; semantics undefined)`() {
        // The accessor is uniform across all streams; semantic validity of
        // writing to stdin is the L2 / consumer's responsibility.
        let stream = Terminal.Stream.stdin
        let write = stream.write
        #expect(write.stream == .stdin)
    }

    @Test
    func `Write is Sendable across isolation boundaries`() async {
        let write = Terminal.Stream.stdout.write
        await Task.detached {
            #expect(write.stream == .stdout)
        }.value
    }
}
