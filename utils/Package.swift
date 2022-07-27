// swift-tools-version: 5.7

import PackageDescription

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
                .product(name: "VisualTests", package: "scale"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SystemPackage", package: "swift-system"),
            ]
        ),
    ]
)
