//
//  IntrinsicHeightDataView.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-07-09.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

/// CollectionView that auto-sizes in StackView
public class IntrinsicHeightCollectionView: UICollectionView {
    
    public override var contentSize: CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

/// TableView that auto-sizes in StackView
public class IntrinsicHeightTableView: UITableView {
    
    public override var contentSize: CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
