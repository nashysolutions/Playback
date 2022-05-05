// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Playback",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Playback",
            targets: ["Playback"]),
    ],
    targets: [
        .target(
            name: "Playback",
            dependencies: [])
    ]
)
