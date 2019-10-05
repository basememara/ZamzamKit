//
//  ColumnsCollectionViewFlowLayout.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-03-17.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/// A flow layout organizes items into a grid dynamically obeying different trait size.
open class ColumnsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /// Number of columns in portrait orientation.
    @IBInspectable open var portraitColumns: Int = 2
    
    /// Number of columns in landscape orientation.
    @IBInspectable open var landscapeColumns: Int = 3
    
    /// Increase columns for larger screens.
    ///
    /// Portrait and landscape columns will be multiplied with this number for regular size class devices.
    @IBInspectable open var multiplierForRegularTrait: CGFloat = 1.5
    
    /// The ratio between width and height while obeying number of columns.
    @IBInspectable open var aspectRatio: CGFloat = 1
    
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
            
            if #available(iOS 11, *) {
                switch sectionInsetReference {
                case .fromContentInset:
                    output += collectionView.contentInset.left + collectionView.contentInset.right
                case .fromLayoutMargins:
                    output += collectionView.layoutMargins.left + collectionView.layoutMargins.right
                case .fromSafeArea:
                    output += collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
                @unknown default:
                    break
                }
            }
            
            output += max(minimumInteritemSpacing, 1) * CGFloat(cellsPerRow - 1)
            return output
        }()
        
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        let itemHeight = itemWidth / aspectRatio
        
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        newBounds != collectionView?.bounds
    }
}
#endif
