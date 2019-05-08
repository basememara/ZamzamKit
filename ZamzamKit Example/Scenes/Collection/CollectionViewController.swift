//
//  Collection.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-12-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit
import ZamzamKit

class CollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet { collectionView.register(cell: CollectionViewCell.self) }
    }
    
    private let viewModels = (0..<1000).map {
        CollectionModels.ViewModel(
            title: "Test \($0 * 10)",
            detail: "Detail \($0 * 100)"
        )
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView[indexPath]
        cell.bind(viewModels[indexPath.row])
        return cell
    }
}
