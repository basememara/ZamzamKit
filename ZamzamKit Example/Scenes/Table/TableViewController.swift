//
//  TableViewController.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit
import ZamzamKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet { tableView.register(nib: TableViewCell.self) }
    }
    
    let viewModels = (0..<1000).map {
        TableModels.ViewModel(
            title: "Test \($0 * 10)",
            detail: "Detail \($0 * 100)"
        )
    }
}

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView[indexPath]
        cell.bind(viewModels[indexPath.row])
        return cell
    }
}
