// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "SwiftVizScale",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "SwiftVizScale",
            targets: ["SwiftVizScale"]
        ),
        .library(name: "ScaleVisualTests", targets: ["SwiftVizScale", "VisualTests"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
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

#if swift(>=5.6)
    // Add the documentation compiler plugin if possible
    package.dependencies.append(
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main") // from: "1.0.0")
    )
#endif
