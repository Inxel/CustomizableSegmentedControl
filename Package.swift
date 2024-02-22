// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomizableSegmentedControl",
    platforms: [.iOS(.v15), .macOS(.v12)], // .tvOS(.v15), .macCatalyst(.v15), .visionOS(.v1)
    products: [
        .library(
            name: "CustomizableSegmentedControl",
            targets: ["CustomizableSegmentedControl"]),
    ],
    targets: [
        .target(
            name: "CustomizableSegmentedControl",
            dependencies: [])
    ]
)
