// swift-tools-version:5.6

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
        .library(
            name: "ZamzamCore",
            targets: ["ZamzamCore"]
        ),
        .library(
            name: "ZamzamUI",
            targets: ["ZamzamUI"]
        ),
        .library(
            name: "ZamzamNotification",
            targets: ["ZamzamNotification"]
        ),
        .library(
            name: "ZamzamLocation",
            targets: ["ZamzamLocation"]
        )
    ],
    targets: [
        .target(
            name: "ZamzamCore"
        ),
        .testTarget(
            name: "ZamzamCoreTests",
            dependencies: ["ZamzamCore"],
            exclude: ["Network/Certificates"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "ZamzamUI",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamUITests",
            dependencies: ["ZamzamUI"]
        ),
        .target(
            name: "ZamzamNotification",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamNotificationTests",
            dependencies: ["ZamzamNotification"]
        ),
        .target(
            name: "ZamzamLocation",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamLocationTests",
            dependencies: ["ZamzamLocation"]
        )
    ]
)
