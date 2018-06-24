//
//  RoundedViews.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-06-24.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

public class RoundedView: UIView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

public class RoundedButton: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

public class RoundedImageView: UIImageView {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
