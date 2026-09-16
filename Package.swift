// swift-tools-version: 6.0

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
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "ZamzamKitTests",
            dependencies: ["ZamzamKit"],
            path: "Tests",
            exclude: ["Network/Certificates"],
            resources: [.process("Resources")],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "ZamzamCore",
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "ZamzamLocation",
            dependencies: ["ZamzamCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "ZamzamNotification",
            dependencies: ["ZamzamCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .target(
            name: "ZamzamUI",
            dependencies: ["ZamzamCore"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
