//
//  ControlsViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-09-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit
import ZamzamKit
import SystemConfiguration

class ControlsViewController: UIViewController {
    
    @IBOutlet private weak var shadowView: UIView! {
        didSet { shadowView.addShadow(ofColor: .black) }
    }
    
    @IBOutlet private weak var fadeView: UIView!
    
    private let mailComposer: MailComposerType = MailComposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension ControlsViewController {
    
    func configure() {
        navigationItem.rightBarButtonItems = [
            BadgeBarButtonItem(
                button: UIButton(type: .contactAdd),
                badgeText: "123",
                target: self,
                action: #selector(test)
            )
        ]
        
        navigationItem.leftBarButtonItems = [
            BadgeBarButtonItem(
                button: UIButton(type: .detailDisclosure),
                badgeText: "abc",
                target: self,
                action: #selector(test)
            ).with {
                $0.badgeFontColor = .black
                $0.badgeBackgroundColor = .green
            }
        ]
    }
    
    @objc func test() {
        
    }
}

private extension ControlsViewController {
    
    @IBAction func alertButtonTapped() {
        present(alert: "Test Alert")
    }
    
    @IBAction func actionSheetButtonTapped(_ sender: UIButton) {
        present(
            alert: "Test Action Sheet",
            message: "Choose your action",
            preferredStyle: .actionSheet,
            additionalActions: [
                UIAlertAction(title: "Action 1") { },
                UIAlertAction(title: "Action 2") { },
                UIAlertAction(title: "Action 3") { }
            ],
            includeCancelAction: true,
            popoverFrom: sender
        )
    }
    
    @IBAction func safariButtonTapped() {
        present(safari: "https://apple.com")
    }
    
    @IBAction func presentShareActivityTapped(_ sender: UIButton) {
        guard let link = URL(string: "https://apple.com") else { return }
        
        let safariActivity = UIActivity.make(
            title: .localized(.openInSafari),
            imageName: "safari-share",
            imageBundle: .zamzamKit,
            handler: {
                guard SCNetworkReachability.isOnline else {
                    return self.present(alert: "Device must be online to view within the browser.")
                }
                
                UIApplication.shared.open(link)
            }
        )
        
        present(
            activities: ["Test Title", link],
            popoverFrom: sender,
            applicationActivities: [safariActivity]
        )
    }
    
    @IBAction func composeMailButtonTapped() {
        guard let controller = mailComposer.makeViewController(email: "test@example.com") else {
            return present(
                alert: "Could Not Send Email",
                message: "Your device could not send e-mail."
            )
        }
        
        present(controller, animated: true)
    }
    
    @IBAction func toggleFadeButtonTapped() {
        fadeView.isHidden ? fadeView.fadeIn() : fadeView.fadeOut()
    }
}
