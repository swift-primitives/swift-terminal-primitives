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

// Platform implementations are provided via extension in:
// - swift-iso-9945 (POSIX: macOS, Linux, etc.)
// - swift-windows-primitives (Windows)
//
// This file is intentionally minimal - it only defines the namespace.
// The actual implementations (isInteractive, size, enterRaw, exitRaw)
// are added by the platform layer.
