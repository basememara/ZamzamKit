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

class SecondViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    var locationManager: LocationManager = {
        return LocationManager(
            desiredAccuracy: kCLLocationAccuracyThreeKilometers,
            distanceFilter: 1000
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.didUpdateLocations.append(locationObserver)
        locationManager.didUpdateHeading.append(headingObserver)
        
        locationManager.requestAuthorization(
            for: .whenInUse,
            startUpdatingLocation: true) {
                guard $0 else {
                    return self.present(
                        alert: "Allow “My App” to Access Your Current Location?".localized,
                        message: "Coordinates needed to calculate your location.".localized,
                        buttonText: "Allow".localized,
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
    
    deinit {
        locationManager.didUpdateLocations.remove(locationObserver)
        locationManager.didUpdateHeading.remove(headingObserver)
    }
}

extension SecondViewController {
    var locationObserver: LocationManager.LocationObserver {
        return Observer {
            print($0.description)
        }
    }
    
    var headingObserver: LocationManager.HeadingObserver {
        return Observer {
            print($0.description)
        }
    }
}

