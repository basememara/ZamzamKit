// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ZamzamKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(name: "ZamzamCore", targets: ["ZamzamCore"]),
        .library(name: "ZamzamLocation", targets: ["ZamzamLocation"]),
        .library(name: "ZamzamNotification", targets: ["ZamzamNotification"]),
        .library(name: "ZamzamUI", targets: ["ZamzamUI"]),
    ],
    targets: [
        .testTarget(
            name: "ZamzamKitTests",
            dependencies: [
                "ZamzamCore",
                "ZamzamLocation",
                "ZamzamNotification",
                "ZamzamUI"
            ],
            path: "Tests",
            exclude: ["Network/Certificates"],
            resources: [.process("Resources")],
            swiftSettings: [.swiftLanguageMode(.v6)]
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
