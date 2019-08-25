// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZamzamKit",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "ZamzamKit",
            targets: ["ZamzamKit"]
        ),
        .library(
            name: "ZamzamLocation",
            targets: ["ZamzamLocation"]
        ),
        .library(
            name: "ZamzamNotification",
            targets: ["ZamzamNotification"]
        ),
        .library(
            name: "ZamzamUI",
            targets: ["ZamzamUI"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:ZamzamInc/ZamzamCore.git", .branch("develop"))
    ],
    targets: [
        .target(
            name: "ZamzamKit",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamKitTests",
            dependencies: ["ZamzamKit"]
        ),
        .target(
            name: "ZamzamLocation",
            dependencies: ["ZamzamKit"],
            exclude: {
                var exclude = [String]()
                
                #if !(os(iOS) || os(watchOS))
                exclude.append("LocationWorkerType.swift")
                exclude.append("LocationWorker.swift")
                #endif
                
                return exclude
            }()
        ),
        .testTarget(
            name: "ZamzamLocationTests",
            dependencies: ["ZamzamLocation"]
        ),
        .target(
            name: "ZamzamNotification",
            dependencies: ["ZamzamKit"],
            exclude: {
                var exclude = [String]()
                
                #if !(os(iOS) || os(watchOS))
                exclude.append("UNNotificationAttachment.swift")
                exclude.append("UNNotificationTriggerDateType.swift")
                exclude.append("UNUserNotificationCenter.swift")
                #endif
                
                return exclude
            }()
        ),
        .testTarget(
            name: "ZamzamNotificationTests",
            dependencies: ["ZamzamNotification"]
        ),
        .target(
            name: "ZamzamUI",
            dependencies: ["ZamzamKit"],
            exclude: {
                var exclude = [String]()
                
                #if !os(iOS)
                exclude.append("iOS")
                #endif

                #if !os(watchOS)
                exclude.append("watchOS")
                #endif
                
                return exclude
            }()
        ),
        .testTarget(
            name: "ZamzamUITests",
            dependencies: ["ZamzamUI"]
        )
    ]
)
