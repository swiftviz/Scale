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
//        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "SwiftVizScale",
            targets: ["SwiftVizScale"]
        ),
        .library(name: "ScaleVisualTests", targets: ["SwiftVizScale", "VisualTests"]),
//        .plugin(name: "GenerateDocImages", targets: ["GenerateDocImages"]),
        .executable(name: "GenerateDocImages", targets: ["GenerateDocImages"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-system", from: "0.0.3"),
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
        ),
//        .plugin(name: "GenerateDocImages",
//                capability: .command(
//                    intent: .custom(verb: "generate-documentation-images",
//                                    description: "Generates images for DocC documentation."),
//                                    permissions: [
//                                        .writeToPackageDirectory(reason: "This command generates images for documentation.")
//                                    ]
//                ),
//                dependencies: [
//                    .productItem(name: "VisualTests", package: "SwiftVizScale")
//                    // ^ can't depend on libraries created in THIS Oackage.swift (with Swift 5.7)
//                    // You get the error:
//                    // unknown package 'SwiftVizScale' in dependencies of target 'GenerateDocImages'; valid packages are: 'swift-numerics', 'swift-docc-plugin'
//                ]),
    ]
)

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
