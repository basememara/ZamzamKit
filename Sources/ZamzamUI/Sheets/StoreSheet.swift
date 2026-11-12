//
//  StoreSheet.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-08-07.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

#if os(iOS) && canImport(StoreKit)
import StoreKit
import SwiftUI

public extension View {
    /// Presents the App Store page of an item over the app's key window.
    ///
    /// - Parameters:
    ///   - itunesID: The item's App Store identifier.
    ///   - affiliateToken: An affiliate identifier credited with a purchase made from the page.
    ///   - campaignToken: An App Analytics campaign name.
    ///   - application: The application whose active scene presents the page.
    ///   - completion: Called once the page is on screen, or when it can't load or the app has no key window.
    func open(
        itunesID: String,
        affiliateToken: String? = nil,
        campaignToken: String? = nil,
        application: UIApplication,
        completion: (() -> Void)? = nil
    ) {
        // Temporary solution until supported by SwiftUI:
        // https://stackoverflow.com/q/64503955
        let viewController = SKStoreProductViewController()
        var parameters = [SKStoreProductParameterITunesItemIdentifier: itunesID]

        if let affiliateToken {
            parameters[SKStoreProductParameterAffiliateToken] = affiliateToken
        }

        if let campaignToken {
            parameters[SKStoreProductParameterCampaignToken] = campaignToken
        }

        viewController.loadProduct(withParameters: parameters) { loaded, _ in
            guard let rootViewController = application.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .compactMap({ $0 as? UIWindowScene })
                    .first?
                    .windows
                    .first(where: \.isKeyWindow)?
                    .rootViewController,
                  loaded
            else {
                completion?()
                return
            }

            rootViewController.present(viewController, animated: true, completion: completion)
        }
    }
}
#endif
