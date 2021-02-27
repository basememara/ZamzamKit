//
//  BaseNibView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2/21/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/// The `UIView` class with a `.xib` file by the same name added as a subview as file owner.
open class XIBView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
}

private extension XIBView {

    func loadFromNib() {
        guard let subView = UINib(nibName: "\(type(of: self))", bundle: nil)
            .instantiate(withOwner: self, options: nil).first as? UIView else {
                return
        }

        subView.frame = bounds
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(subView)
    }
}
#endif
