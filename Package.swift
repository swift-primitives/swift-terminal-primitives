// swift-tools-version: 6.3

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
            name: "Terminal Primitives Core",
            targets: ["Terminal Primitives Core"]
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
        // MARK: - Core
        .target(
            name: "Terminal Primitives Core",
            dependencies: [
                .product(name: "Kernel Primitives", package: "swift-kernel-primitives")
            ]
        ),

        // MARK: - Input
        .target(
            name: "Terminal Input Primitives",
            dependencies: [
                "Terminal Primitives Core",
                .product(name: "Input Primitives", package: "swift-input-primitives"),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Terminal Primitives",
            dependencies: [
                "Terminal Primitives Core",
                "Terminal Input Primitives",
            ]
        ),
        .testTarget(
            name: "Terminal Primitives Tests",
            dependencies: [
                "Terminal Primitives",
                "Terminal Primitives Core",
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
