//
//  CalendarViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-09-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit
import EventKit
import ZamzamKit

class CalendarViewController: UITableViewController {
    
    private let notificationCenter = NotificationCenter.default
    private lazy var activityIndicator = tableView.makeActivityIndicator()
    
    private let eventsWorker: EventsWorkerType = EventsWorker()
    private var elements = [EKEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAccess()
    }
}

// MARK: - Events

private extension CalendarViewController {
    
    func configure() {
        tableView.refreshControl = UIRefreshControl().with {
            $0.addTarget(self, action: #selector(loadData), for: .valueChanged)
        }
        
        notificationCenter.addObserver(
            for: .UIApplicationDidBecomeActive,
            selector: #selector(loadData),
            from: self
        )
    }
    
    @objc func loadData() {
        beginRefreshing()
        
        eventsWorker.fetchEvents(
            from: Date(timeIntervalSinceNow: 60 * 60 * 24 * -30),
            to: Date(timeIntervalSinceNow: 60 * 60 * 24 * 30),
            completion: { [weak self] in
                self?.endRefreshing()
                
                guard let value = $0.value, $0.isSuccess else  {
                    self?.presentAlert(for: $0.error)
                    return
                }
                
                self?.elements = value.sorted { $0.startDate < $1.startDate }
                self?.tableView.reloadData()
            }
        )
    }
}

// MARK: - Actions

private extension CalendarViewController {
    
    func requestAccess() {
        eventsWorker.requestAccess { [weak self] granted in
            guard granted else {
                self?.presentAlert(for: .unauthorized)
                return
            }
            
            self?.loadData()
        }
    }
    
    func createData() {
        beginRefreshing()
        
        let taskGroup = DispatchGroup()
        
        taskGroup.enter()
        eventsWorker.createEvent(
            configure: {
                $0.title = "Single: Meeting with \(Int(arc4random_uniform(2000)))"
                $0.notes = "Don't forget to bring the meeting memos"
                $0.location = "Room \(Int(arc4random_uniform(100)))"
                $0.startDate = Date().addingTimeInterval(Double(Int.random(in: 0..<86400)))
                $0.endDate = Date().addingTimeInterval(Double(Int.random(in: 86400...259200)))
            },
            completion: { [weak self] in
                taskGroup.leave()
                
                if $0.isFailure {
                    self?.presentAlert(for: $0.error)
                }
            }
        )
        
        taskGroup.enter()
        eventsWorker.createEvents(
            from: [
                "List 1",
                "List 2",
                "List 3"
            ],
            configure: {
                $0.title = "\($1): Meeting with \(Int(arc4random_uniform(2000)))"
                $0.notes = "Don't forget to bring the meeting memos"
                $0.location = "Room \(Int(arc4random_uniform(100)))"
                $0.startDate = Date().addingTimeInterval(Double(Int.random(in: 0..<86400)))
                $0.endDate = Date().addingTimeInterval(Double(Int.random(in: 86400...259200)))
            },
            completion: { [weak self] in
                taskGroup.leave()
                
                if $0.isFailure {
                    self?.presentAlert(for: $0.error)
                }
            }
        )
        
        taskGroup.notify(queue: .main) { [weak self] in
            self?.loadData()
        }
    }
    
    func reset() {
        beginRefreshing()
        
        eventsWorker.deleteEvents(withIdentifiers: elements.map { $0.eventIdentifier }) { [weak self] in
            self?.loadData()
            
            if $0.isFailure {
                self?.presentAlert(for: $0.error)
            }
        }
    }
}

// MARK: - Interactions

private extension CalendarViewController {
    
    @IBAction func addTapped(_ sender: Any) {
        createData()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        reset()
    }
}

// MARK: - Delegates

extension CalendarViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        
        let cell = tableView[indexPath].with {
            $0.textLabel?.text = element.title
            $0.detailTextLabel?.text = "\(element.startDate.string(format: "MMM d, h:mm a"))"
                + " to \(element.endDate.string(format: "MMM d, h:mm a"))"
        }
        
        return cell
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = elements[indexPath.row]
        
        return UISwipeActionsConfiguration(
            actions: [
                UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, completion in
                    self.eventsWorker.deleteEvent(withIdentifier: model.eventIdentifier) {
                        completion($0.isSuccess)
                        
                        guard $0.isSuccess else {
                            self.presentAlert(for: $0.error)
                            return
                        }
                        
                        self.loadData()
                    }
                },
                UIContextualAction(style: .normal, title: "Modify") { [unowned self] _, _, completion in
                    self.eventsWorker.updateEvent(
                        withIdentifier: model.eventIdentifier,
                        configure: {
                            $0.endDate = Date().addingTimeInterval(Double(Int.random(in: 86400...259200)))
                        },
                        completion: {
                            completion($0.isSuccess)
                            
                            guard let value = $0.value, $0.isSuccess else {
                                self.presentAlert(for: $0.error)
                                return
                            }
                            
                            self.elements[indexPath.row] = value
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    )
                }
            ]
        )
    }
}

// MARK: - Helpers

private extension CalendarViewController {
    
    func beginRefreshing() {
        activityIndicator.startAnimating()
    }
    
    func endRefreshing() {
        activityIndicator.stopAnimating()
        
        guard tableView.refreshControl?.isRefreshing == true else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func presentAlert(for error: ZamzamError?) {
        switch error {
        case .unauthorized?:
            present(
                alert: .localized(.allowCalendarAlert),
                message: .localized(.allowCalendarMessage),
                buttonText: .localized(.allow),
                includeCancelAction: true,
                handler: {
                    guard let settings = URL(string: UIApplicationOpenSettingsURLString) else { return }
                    UIApplication.shared.open(settings)
            }
            )
        case .other(let error)?:
            present(
                alert: "Calendar Error",
                message: error?.localizedDescription
            )
        default:
            present(
                alert: "Calendar Error",
                message: "\(String(describing: error))"
            )
        }
    }
}
