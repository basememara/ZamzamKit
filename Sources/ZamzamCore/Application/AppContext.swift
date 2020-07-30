//
//  AppContext.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/29/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle

/// Provides details of the current app.
public protocol AppContext {}

public extension AppContext {

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

public extension AppContext {
    
    /// Check if app is an extension target.
    var isAppExtension: Bool {
        Bundle.main.bundlePath.hasSuffix(".appex")
    }
	
	/// Check if app is running in TestFlight mode.
	var isInTestFlight: Bool {
		// http://stackoverflow.com/questions/12431994/detect-testflight
		Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
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
    
    /// Check if application is attached to a debugger.
    var isDebuggerAttached: Bool {
        // https://stackoverflow.com/a/33177600
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}
