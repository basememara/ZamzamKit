//
//  CollectionViewColumnFlowLayout.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-11.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

open class ColumnsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /// Number of columns in portrait orientation
    @IBInspectable
    open var portraitColumns: Int = 1
    
    /// Number of columns in landscape orientation
    @IBInspectable
    open var landscapeColumns: Int = 0
    
    /// Increase columns for larger screens
    @IBInspectable
    open var multiplierForRegularTrait: CGFloat = 0
    
    /// The ratio between width and height while obeying number of columns
    @IBInspectable
    open var aspectRatio: CGFloat = 1
    
    open override func prepare() {
        super.prepare()
        
        var cellsPerRow = UIDevice.current.orientation.isLandscape && landscapeColumns > 0
            ? landscapeColumns : portraitColumns
        
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular && multiplierForRegularTrait > 1 {
            cellsPerRow = Int(round(CGFloat(cellsPerRow) * multiplierForRegularTrait))
        }
        
        guard let collectionView = collectionView, cellsPerRow > 0 else { return }
        
        let marginsAndInsets: CGFloat = {
            var output = sectionInset.left + sectionInset.right
            
            if #available(iOS 11.0, *) {
                output += collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
            }
            
            output += minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            return output
        }()
        
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        let itemHeight = itemWidth / aspectRatio
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds != collectionView?.bounds
    }
}
