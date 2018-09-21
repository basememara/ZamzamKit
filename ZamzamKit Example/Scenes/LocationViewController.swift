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
    
    var locationsWorker: LocationsWorkerType = LocationsWorker(
        desiredAccuracy: kCLLocationAccuracyThreeKilometers,
        distanceFilter: 1000
    )
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationsWorker.addObserver(locationObserver)
        locationsWorker.addObserver(headingObserver)
        
        locationsWorker.requestAuthorization(
            for: .whenInUse,
            startUpdatingLocation: true) {
                guard $0 else {
                    return self.present(
                        alert: .localized(.allowLocationAlert),
                        message: .localized(.allowLocationMessage),
                        buttonText: .localized(.allow),
                        includeCancelAction: true,
                        handler: {
                            guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settings)
                        }
                    )
                }
                
                self.locationsWorker.startUpdatingHeading()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationsWorker.removeObservers()
    }
    
    deinit {
        locationsWorker.removeObservers()
    }
}

extension LocationViewController {
    
    var locationObserver: Observer<LocationsWorker.LocationHandler> {
        return Observer { [weak self] in
            self?.outputLabel.text = $0.description
        }
    }
    
    var headingObserver: Observer<LocationsWorker.HeadingHandler> {
        return Observer {
            print($0.description)
        }
    }
}

