// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-bins",
    targets: [
        .executableTarget(
            name: "set-kitty",
            dependencies: []),
        .executableTarget(
            name: "dnc-post",
            dependencies: []),
    ]
)
