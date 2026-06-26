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

extension Terminal.Stream {
    /// Accessor for write operations on this stream.
    ///
    /// Mirrors the existing `.read` accessor (see `Terminal.Stream.Read`).
    /// L1 declares the typed surface; L2 (e.g., `swift-iso-9945`) provides
    /// the syscall implementation as an extension on `Terminal.Stream.Write`.
    ///
    /// ## Phase 1.5 design choices (articulated for review)
    ///
    /// - **Accessor struct mirroring Read** — the symmetry with the existing
    ///   `Terminal.Stream.Read` keeps the API shape predictable. Both types
    ///   are pure value wrappers around the underlying `Stream` (FD identity).
    /// - **Copyable + Sendable** — diagnostics are routinely passed across
    ///   isolation boundaries (test fixtures, async reporter contexts).
    ///   `~Copyable` would be value-light but block trivial composition with
    ///   no ownership benefit. The underlying file descriptor is owned
    ///   process-wide, not per-instance.
    /// - **No ANSI / color in Phase 1.5** — the brief flagged this as
    ///   potentially Phase 2 work. The Write accessor is the substrate;
    ///   colored / styled output composes on top of it later.
    /// - **L2 syscall extension deferred** — Phase 1.5 declares the L1 type
    ///   only. The corresponding L2 extension on `Terminal.Stream.Write`
    ///   (callAsFunction emitting to file descriptor via `write(2)` /
    ///   `WriteFile`) is a separate dispatch in `swift-iso-9945` (POSIX) +
    ///   future Windows L2. Surface this as Open Question OQ-T2 in the
    ///   Phase 1.5 HANDOFF.
    public struct Write: Sendable {
        /// The stream to write to.
        public let stream: Terminal.Stream

        /// Creates a write accessor for the given stream.
        @inlinable
        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

// MARK: - Property Accessor

extension Terminal.Stream {
    /// Accessor for write operations on this stream.
    ///
    /// ```swift
    /// let stream: Terminal.Stream = .stdout
    /// stream.write(...)   // L2 provides callAsFunction
    /// ```
    @inlinable
    public var write: Write {
        Write(stream: self)
    }
}

// Note: `callAsFunction(_ string: String)` and other write methods on
// `Terminal.Stream.Write` are provided via extension at L2 (POSIX:
// `swift-iso-9945`; Windows: future). L1 declares the typed surface only.
