//
//  SecondViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 3/17/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import CoreLocation
import ZamzamKit

class LocationViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    var locationManager: LocationManager = {
        return LocationManager(
            desiredAccuracy: kCLLocationAccuracyThreeKilometers,
            distanceFilter: 1000
        )
    }()
    
    var locationObserver = Observer<LocationManager.LocationHandler> {
        print($0.description)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.addObserver(locationObserver)
        locationManager.addObserver(locationObserver)
        
        locationManager.requestAuthorization(
            for: .whenInUse,
            startUpdatingLocation: true) {
                guard $0 else {
                    return self.present(
                        alert: .localized(.alert),
                        message: .localized(.message),
                        buttonText: .localized(.allow),
                        includeCancelAction: true,
                        handler: {
                            guard let settings = URL(string: UIApplicationOpenSettingsURLString) else { return }
                            UIApplication.shared.open(settings)
                        }
                    )
                }
                
                self.locationManager.startUpdatingHeading()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.removeObservers()
    }
    
    deinit {
        locationManager.removeObservers()
    }
}

extension LocationViewController {
    
    var headingObserver: Observer<LocationManager.HeadingHandler> {
        return Observer {
            print($0.description)
        }
    }
}

extension Localizable {
    static let allow = Localizable(NSLocalizedString("Allow", comment: "For dialogs"))
    static let alert = Localizable(NSLocalizedString("Allow “My App” to Access Your Current Location?", comment: "For dialogs"))
    static let message = Localizable(NSLocalizedString("Coordinates needed to calculate your location.", comment: "For dialogs"))
}

