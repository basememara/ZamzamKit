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
    
    var locationObserver: LocationManager.LocationObserver = Observer {
        print($0.description)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.didUpdateLocations.remove(locationObserver)
        locationManager.didUpdateHeading.remove(headingObserver)
    }
    
    deinit {
        locationManager.didUpdateLocations.remove(locationObserver)
        locationManager.didUpdateHeading.remove(headingObserver)
    }
}

extension SecondViewController {
    
    var headingObserver: LocationManager.HeadingObserver {
        return Observer {
            print($0.description)
        }
    }
}

