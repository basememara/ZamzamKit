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
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var fadeView: UIView!
    
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            let image = UIImage(from: .lightGray)
            submitButton.setBackgroundImage(image, for: .selected)
        }
    }
    
    private lazy var inputDoneToolbar: UIToolbar = .makeInputDoneToolbar(
        target: self,
        action: #selector(endEditing)
    )
    
    private lazy var inputNextToolbar: UIToolbar = .makeInputNextToolbar(
        target: self,
        action: #selector(endEditing)
    )
    
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
                badgeText: SCNetworkReachability.isOnline ? "On" : "Off",
                target: self,
                action: #selector(test)
            ).with {
                $0.badgeFontColor = SCNetworkReachability.isOnline ? .black : .white
                $0.badgeBackgroundColor = SCNetworkReachability.isOnline ? .green : .red
            }
        ]
    }
    
    @objc func test() {
        
    }
}

// MARK: - Interactions

private extension ControlsViewController {
    
    @IBAction func alertButtonTapped() {
        present(
            alert: "Test Alert",
            message: "This is the message body.",
            additionalActions: [
                UIAlertAction(title: "Action 123") { }
            ],
            includeCancelAction: true
        )
    }
    
    @IBAction func actionSheetButtonTapped(_ sender: UIButton) {
        present(
            actionSheet: "Test Action Sheet",
            message: "Choose your action",
            popoverFrom: sender,
            additionalActions: [
                UIAlertAction(title: "Action 1") { },
                UIAlertAction(title: "Action 2") { },
                UIAlertAction(title: "Action 3") { }
            ],
            includeCancelAction: true
        )
    }
    
    @IBAction func promptButtonTapped() {
        self.present(
            prompt: "Test Prompt",
            message: "Enter user input.",
            placeholder: "Your placeholder here",
            response: {
                self.present(
                    alert: "User Response",
                    message: $0
                )
            }
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
    
    @IBAction func modalButtonTapped() {
        let modalView = ModalView.loadNIB().with {
            $0.delegate = self
        }
        
        present(control: modalView)
    }
    
    @IBAction func submitButtonTapped() {
        present(
            alert: "Are you sure you want to submit?",
            includeCancelAction: true,
            handler: { [unowned self] in
                self.submitButton.isSelected = true
                
                guard let url = self.imageView.image?.pngToDisk() else { return }
                print(url)
            }
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
    
    @IBAction func textFieldDidEditingBegin(_ sender: UITextField) {
        sender.inputAccessoryView = inputDoneToolbar
    }
}

// MARK: - Delegates

extension ControlsViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = inputNextToolbar
        return true
    }
}

extension ControlsViewController: ModalViewDelegate {
    
    func modalViewDidApply() {
        print("Applied modal")
    }
}
