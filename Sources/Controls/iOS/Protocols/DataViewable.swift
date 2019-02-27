//
//  DataViewable.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public protocol DataViewable: class {
    var backgroundView: UIView? { get set }
    func reloadData()
}

// Align API's for table and collections views
// http://basememara.com/protocol-oriented-tableview-collectionview/

extension UITableView: DataViewable {}
extension UICollectionView: DataViewable {}
