// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ZamzamKit",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "ZamzamCore",
            targets: ["ZamzamCore"]
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
    targets: [
        .target(
            name: "ZamzamCore",
            exclude: {
                var exclude = [String]()

                #if os(macOS)
                exclude.append("Extensions/Font.swift")
                #endif
                
                #if os(tvOS)
                exclude.append("Extensions/FileManager.swift")
                #endif
                
                #if !os(iOS)
                exclude.append("Utilities/BackgroundTask.swift")
                #endif
                
                #if !(os(iOS) || os(watchOS))
                exclude.append("Utilities/WatchSession.swift")
                #endif
                
                return exclude
            }()
        ),
        .testTarget(
            name: "ZamzamCoreTests",
            dependencies: ["ZamzamCore"]
        ),
        .target(
            name: "ZamzamLocation",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamLocationTests",
            dependencies: ["ZamzamLocation"]
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
            name: "ZamzamUI",
            dependencies: ["ZamzamCore"],
            exclude: {
                var exclude = [String]()
                
                #if !os(iOS)
                    // TODO: Macro doesn't work?
                    //exclude.append("Platforms/UIKit")
                #endif
                
                #if !os(watchOS)
                    exclude.append("Platforms/WatchKit")
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
