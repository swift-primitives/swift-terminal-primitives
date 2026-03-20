// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-terminal-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Terminal Primitives",
            targets: ["Terminal Primitives"]
        ),
        .library(
            name: "Terminal Input Primitives",
            targets: ["Terminal Input Primitives"]
        ),
        .library(
            name: "Terminal Primitives Test Support",
            targets: ["Terminal Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-kernel-primitives"),
        .package(path: "../swift-input-primitives"),
        .package(path: "../swift-ascii-primitives"),
    ],
    targets: [
        .target(
            name: "Terminal Primitives",
            dependencies: [
                .product(name: "Kernel Primitives", package: "swift-kernel-primitives")
            ]
        ),
        .target(
            name: "Terminal Input Primitives",
            dependencies: [
                "Terminal Primitives",
                .product(name: "Input Primitives", package: "swift-input-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),
        .testTarget(
            name: "Terminal Primitives Tests",
            dependencies: [
                "Terminal Primitives",
            ]
        ),
        .testTarget(
            name: "Terminal Input Primitives Tests",
            dependencies: [
                "Terminal Input Primitives",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Terminal Primitives Test Support",
            dependencies: [
                "Terminal Primitives",
                .product(name: "Kernel Primitives Test Support", package: "swift-kernel-primitives"),
                .product(name: "Input Primitives Test Support", package: "swift-input-primitives"),
            ],
            path: "Tests/Support"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
