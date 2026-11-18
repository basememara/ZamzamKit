//
//  Distribution.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/29/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle

/// Provides details of the current app.
public protocol Distribution: Sendable {}

// MARK: - App

public extension Distribution {
	/// App's name.
	var appDisplayName: String? {
		// http://stackoverflow.com/questions/28254377/get-app-name-in-swift
		Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
	}

	/// App's bundle ID.
	var appBundleID: String? { Bundle.main.bundleIdentifier }

	/// App's current version.
	var appVersion: String? {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}

	/// App current build number.
	var appBuild: String? {
		Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
	}
}

// MARK: - Environment

public extension Distribution {
    /// Check if app is an extension target.
    var isAppExtension: Bool {
        Bundle.main.bundlePath.hasSuffix(".appex")
    }

    /// Check if app is running in TestFlight mode.
    var isInTestFlight: Bool {
        guard !isRunningOnSimulator, !isAdHocDistributed, let receiptURL = Bundle.main.appStoreReceiptURL else { return false }

        #if os(macOS)
        // A Mac receipt is named "receipt" in TestFlight too, so the environment is read from inside it
        return (try? Data(contentsOf: receiptURL)).map(isSandboxReceipt) ?? false
        #else
        // https://stackoverflow.com/questions/18282326/how-can-i-detect-if-the-currently-running-app-was-installed-from-the-app-store
        return receiptURL.lastPathComponent == "sandboxReceipt"
        #endif
    }

    /// Check if app is ad-hoc distributed.
    var isAdHocDistributed: Bool {
        // https://stackoverflow.com/questions/18282326/how-can-i-detect-if-the-currently-running-app-was-installed-from-the-app-store
        Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil
    }

    /// Check if application is running on simulator (read-only).
    var isRunningOnSimulator: Bool {
        // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    /// Check if application is running in App Store environment.
    var isRunningInAppStore: Bool {
        // https://stackoverflow.com/questions/18282326/how-can-i-detect-if-the-currently-running-app-was-installed-from-the-app-store
        !isRunningOnSimulator && !isInTestFlight && !isAdHocDistributed
    }
}

// A receipt names the store environment that issued it: "Production", or "ProductionSandbox" for TestFlight's
func isSandboxReceipt(_ receipt: Data) -> Bool {
    receipt.contains(Data("ProductionSandbox".utf8))
}

// MARK: - Device

public extension Distribution {
    /// The operating system the code is compiled for: `"iOS"`, `"watchOS"` or `"macOS"`.
    var platform: String {
        #if os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(macOS)
        return "macOS"
        #endif
    }
}
