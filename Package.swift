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
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(
            name: "SwiftVizScale",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
        .target(
            name: "VisualTests",
            dependencies: ["SwiftVizScale"]
        ),
        .testTarget(
            name: "SwiftVizScaleTests",
            dependencies: [
                "SwiftVizScale",
            ]
        ),
    ]
)

#if swift(>=5.6)
// plugin support is only available for Swift 5.6 and later
package.dependencies += [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
]
#endif

// Checking macOS build w/ Xcode 14 beta
// xcodebuild clean test -scheme SwiftVizScale-Package -destination 'platform=macOS,arch=arm64'

// Checking iOS build w/ Xcode 14 beta
// xcodebuild clean test -scheme SwiftVizScale-Package -destination 'platform=iOS Simulator,OS=16.0,name=iPhone 8'

// Checking tvOS build w/ Xcode 14 beta
// xcodebuild clean build -scheme SwiftVizScale-Package -destination 'platform=tvOS Simulator,OS=16.0,name=Apple TV'

// Checking watchOS build w/ Xcode 14 beta
// xcodebuild clean build -scheme SwiftVizScale-Package -destination 'platform=watchOS Simulator,OS=9.0,name=Apple Watch Series 6 - 44mm'

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
