// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-terminal-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Terminal Primitive",
            targets: ["Terminal Primitive"]
        ),
        .library(
            name: "Terminal Error Primitives",
            targets: ["Terminal Error Primitives"]
        ),
        .library(
            name: "Terminal Primitives",
            targets: ["Terminal Primitives"]
        ),
        .library(
            name: "Terminal Primitives Test Support",
            targets: ["Terminal Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-error-primitives.git",
            branch: "main"
        )
    ],
    targets: [

        .target(
            name: "Terminal Primitive",
            dependencies: []
        ),

        .target(
            name: "Terminal Error Primitives",
            dependencies: [
                "Terminal Primitive",
                .product(name: "Error Primitives", package: "swift-error-primitives"),
            ]
        ),

        .target(
            name: "Terminal Primitives",
            dependencies: [
                "Terminal Primitive",
                "Terminal Error Primitives",
            ]
        ),
        .testTarget(
            name: "Terminal Primitives Tests",
            dependencies: [
                "Terminal Primitive",
                "Terminal Primitives",
            ]
        ),

        .target(
            name: "Terminal Primitives Test Support",
            dependencies: [
                "Terminal Primitives"
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
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
