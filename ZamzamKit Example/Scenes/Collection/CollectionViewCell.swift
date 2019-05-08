//
//  CollectionViewCell.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-12-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
}

extension CollectionViewCell {
    
    func bind(_ model: CollectionModels.ViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
    }
}
