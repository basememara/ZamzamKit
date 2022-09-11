// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ZamzamKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(name: "ZamzamKit", targets: ["ZamzamKit"]),
        .library(name: "ZamzamCore", targets: ["ZamzamCore"]),
        .library(name: "ZamzamLocation", targets: ["ZamzamLocation"]),
        .library(name: "ZamzamNotification", targets: ["ZamzamNotification"]),
        .library(name: "ZamzamUI", targets: ["ZamzamUI"]),
    ],
    targets: [
        .target(
            name: "ZamzamKit",
            dependencies: [
                "ZamzamCore",
                "ZamzamLocation",
                "ZamzamNotification",
                "ZamzamUI"
            ]
        ),
        .testTarget(
            name: "ZamzamKitTests",
            dependencies: ["ZamzamKit"],
            exclude: ["Network/Certificates"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "ZamzamCore"
        ),
        .target(
            name: "ZamzamLocation",
            dependencies: ["ZamzamCore"]
        ),
        .target(
            name: "ZamzamNotification",
            dependencies: ["ZamzamCore"]
        ),
        .target(
            name: "ZamzamUI",
            dependencies: ["ZamzamCore"]
        )
    ]
)
