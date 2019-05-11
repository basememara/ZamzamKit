//
//  TableViewCell.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-10-15.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
}

extension TableViewCell {
    
    func bind(_ model: TableModels.ViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
    }
}
