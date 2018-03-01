//
//  NotificationsViewController.swift
//  ZamzamKit
//
//  Created by Basem Emara on 6/4/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit
import UserNotifications
import ZamzamKit

protocol ViewControllerDelegate: class {
    func update()
}

class NotificationsViewController: UITableViewController, ViewControllerDelegate {

    lazy var viewModel: NotificationsViewModel = {
        NotificationsViewModel(delegate: self)
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        tableView.makeActivityIndicator()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.update()
    }
    
    func update() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = viewModel.elements[indexPath.row]
    
        let cell = tableView[indexPath].with {
            $0.textLabel?.text = element.content.body
            $0.detailTextLabel?.text = viewModel.detailDisplay(for: element)
        }
        
        return cell
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

class NotificationsViewModel {
    private let userNotification = UNUserNotificationCenter.current()
    
    var elements = [UNNotificationRequest]()
    weak var delegate: ViewControllerDelegate?
    
    init(delegate: ViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func update() {
        userNotification.getPendingNotificationRequests {
            self.elements = $0.sorted {
                guard let date1 = ($0.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate(),
                    let date2 = ($1.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
                    else { return false }
                
                return date1 < date2
            }
            
            DispatchQueue.main.async {
                self.delegate?.update()
            }
        }
    }
}

extension NotificationsViewModel {

    func detailDisplay(for element: UNNotificationRequest) -> String? {
        switch element.trigger {
        case let trigger as UNCalendarNotificationTrigger:
            return trigger.nextTriggerDate()?.string(format: "MMM d, h:mm a")
        case let trigger as UNTimeIntervalNotificationTrigger:
            return trigger.nextTriggerDate()?.string(format: "MMM d, h:mm a")
        default:
            return nil
        }
    }
}
