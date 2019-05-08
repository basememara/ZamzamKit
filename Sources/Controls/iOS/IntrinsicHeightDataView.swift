//
//  IntrinsicHeightDataView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-07-09.
//  Copyright © 2018 Zamzam. All rights reserved.
//
//  Resizing UITableView to fit content:
//  https://stackoverflow.com/a/48623673
//

import UIKit

/// TableView that auto-sizes in StackView.
open class IntrinsicHeightTableView: UITableView {
    
    open override var contentSize: CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
