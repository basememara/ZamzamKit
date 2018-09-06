//
//  RoundedViews.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-06-24.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

open class RoundedView: UIView {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

open class RoundedButton: UIButton {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

open class RoundedImageView: UIImageView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
