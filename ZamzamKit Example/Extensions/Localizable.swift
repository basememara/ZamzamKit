//
//  Localizable.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-09-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import ZamzamKit

extension Localizable {
    static let allow = Localizable(NSLocalizedString("Allow", comment: "For dialogs"))
    
    static let allowLocationAlert = Localizable(NSLocalizedString("Allow “My App” to Access Your Current Location?", comment: "For dialogs"))
    static let allowLocationMessage = Localizable(NSLocalizedString("Coordinates needed to calculate your location.", comment: "For dialogs"))
    
    static let allowCalendarAlert = Localizable(NSLocalizedString("Allow “My App” to Access Your Calendar?", comment: "For dialogs"))
    static let allowCalendarMessage = Localizable(NSLocalizedString("Calendar needed to display and create events.", comment: "For dialogs"))
}
