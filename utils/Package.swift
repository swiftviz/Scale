// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScaleImageGenerator",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(name: "genimages", targets: ["ScaleImageGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-system", from: "0.0.3"),
        .package(url: "https://github.com/swiftviz/scale", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "ScaleImageGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "ScaleVisualTests", package: "scale"),
            ]
        ),
    ]
)
