//
//  BaseNibView.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/21/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UIKit

/// The UIView class with a .xib file by the same name wired up.
open class BaseNibView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// Process common code on initialization.
    public func commonInit() {
        loadFromNib()
    }
}
