// swift-tools-version:5.6

import Foundation
import PackageDescription

let package = Package(
    name: "SwiftVizScale",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
//        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "SwiftVizScale",
            targets: ["SwiftVizScale"]
        ),
        .library(name: "ScaleVisualTests", targets: ["SwiftVizScale", "VisualTests"]),
        .executable(name: "GenerateDocImages", targets: ["GenerateDocImages"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-system", from: "0.0.3"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftVizScale",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
            ]
        ),
        .target(
            name: "VisualTests",
            dependencies: ["SwiftVizScale"]
        ),
        .testTarget(
            name: "SwiftVizScaleTests",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
                "SwiftVizScale",
            ]
        ),
        .executableTarget(
            name: "GenerateDocImages",
            dependencies: [
                "VisualTests",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SystemPackage", package: "swift-system"),
            ]
        )
    ]
)

// Checking iOS build
// xcodebuild clean build -scheme SwiftVizScale-Package -destination 'platform=iOS Simulator,OS=16.0,name=iPhone 8'

if ProcessInfo.processInfo.environment["BENCHMARK"] != nil {
    package.products.append(
        .executable(name: "scale-benchmark", targets: ["scale-benchmark"])
    )
    package.dependencies.append(
        .package(url: "https://github.com/google/swift-benchmark", from: "0.1.0")
    )
    package.targets.append(
        .executableTarget(
            name: "scale-benchmark",
            dependencies: [
                "SwiftVizScale",
                .product(name: "Benchmark", package: "swift-benchmark"),
            ]
        )
    )
}
