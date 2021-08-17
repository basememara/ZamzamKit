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
    /// Presents iTunes Store product information using the given App Store parameters.
    ///
    /// - Parameters:
    ///   - itunesID: The iTunes identifier for the item you want the store to display when the view controller is presented.
    ///   - affiliateToken: The affiliate identifier you wish to use for any purchase made through the view controller.
    ///   - campaignToken: An App Analytics campaign.
    ///   - application: The application to present the store page from.
    ///   - completion: The block to execute after the presentation finishes.
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

        if let affiliateToken = affiliateToken {
            parameters[SKStoreProductParameterAffiliateToken] = affiliateToken
        }

        if let campaignToken = campaignToken {
            parameters[SKStoreProductParameterCampaignToken] = campaignToken
        }

        viewController.loadProduct(withParameters: parameters) { loaded, _ in
            guard let rootViewController = application.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .compactMap({ $0 as? UIWindowScene })
                    .first?
                    .windows
                    .filter(\.isKeyWindow)
                    .first?
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
