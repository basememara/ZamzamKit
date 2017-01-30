//
//  ZamzamKitable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/29/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

public protocol ZamzamKitable {

}

public extension ZamzamKitable {

	/// App's name (if applicable).
	public var appDisplayName: String? {
		// http://stackoverflow.com/questions/28254377/get-app-name-in-swift
		return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
	}
	
	/// App's bundle ID (if applicable).
	public var appBundleID: String? {
		return Bundle.main.bundleIdentifier
	}

	/// App current build number (if applicable).
	public var appBuild: String? {
		return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
	}
	
	/// App's current version (if applicable).
	public var appVersion: String? {
		return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}
}

// MARK: - Environment
public extension ZamzamKitable {

    /// Check if app is running in debug mode.
	public var isInDebuggingMode: Bool {
		// http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
		#if DEBUG
			return true
		#else
			return false
		#endif
	}
	
	/// Check if app is running in TestFlight mode.
	public var isInTestFlight: Bool {
		// http://stackoverflow.com/questions/12431994/detect-testflight
		return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
	}

	/// Check if application is running on simulator (read-only).
	public var isRunningOnSimulator: Bool {
		// http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
		#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
			return true
		#else
			return false
		#endif
	}

}

public extension ZamzamKitable {
	
	/// Screen height.
	public var screenHeight: CGFloat {
		#if os(iOS) || os(tvOS)
			return UIScreen.main.bounds.height
		#elseif os(watchOS)
			return WKInterfaceDevice.current().screenBounds.height
		#endif
	}
	
	/// Screen width.
	public var screenWidth: CGFloat {
		#if os(iOS) || os(tvOS)
			return UIScreen.main.bounds.width
		#elseif os(watchOS)
			return WKInterfaceDevice.current().screenBounds.width
		#endif
	}
}
