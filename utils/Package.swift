// swift-tools-version: 5.6

import PackageDescription

// This executable is in its own package because including a CLI executable package
// into the Scale library caused Xcode to have a freak out, and fail to present
// SwiftUI previews for targets within that package. By moving it out and into it's
// own thing, Xcode's failing resolution mechanisms seem to be worked around.

let package = Package(
    name: "GenerateDocImages",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/swiftviz/scale", branch: "main"),
        .package(url: "https://github.com/apple/swift-system", from: "0.0.3"),
    ],
    targets: [
        .executableTarget(
            name: "GenerateDocImages",
            dependencies: [
                .product(name: "ScaleVisualTests", package: "scale"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SystemPackage", package: "swift-system"),
            ]
        ),
    ]
)
