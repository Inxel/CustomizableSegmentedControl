// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomizableSegmentedControl",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CustomizableSegmentedControl",
            targets: ["CustomizableSegmentedControl"]
        ),
    ],
    targets: [
        .target(
            name: "CustomizableSegmentedControl",
            dependencies: []
        )
    ]
)
