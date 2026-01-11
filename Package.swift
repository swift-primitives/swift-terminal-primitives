// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-terminal-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Terminal Primitives",
            targets: ["Terminal Primitives"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-kernel-primitives"),
        .package(path: "../swift-test-primitives"),
    ],
    targets: [
        .target(
            name: "Terminal Primitives",
            dependencies: [
                .product(name: "Kernel Primitives", package: "swift-kernel-primitives"),
            ]
        ),
        .testTarget(
            name: "Terminal Primitives Tests",
            dependencies: [
                "Terminal Primitives",
                .product(name: "Test Primitives", package: "swift-test-primitives"),
            ],
            path: "Tests/Terminal Primitives Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
