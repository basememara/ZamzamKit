//
//  GradientView.swift
//  ZamzamKit iOS
//  https://medium.com/@sakhabaevegor/create-a-color-gradient-on-the-storyboard-18ccfd8158c2
//
//  Created by Basem Emara on 2018-08-10.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientView: UIView {
    
    @IBInspectable open var firstColor: UIColor = .clear {
        didSet { configure() }
    }
    
    @IBInspectable open var secondColor: UIColor = .clear {
        didSet { configure() }
    }
    
    @IBInspectable open var isVertical: Bool = true {
        didSet { configure() }
    }
    
    override class open var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

private extension GradientView {
    
    func configure() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        
        layer.colors = [firstColor, secondColor].map { $0.cgColor }
        
        layer.startPoint = isVertical
            ? CGPoint(x: 0, y: 0.5)
            : CGPoint(x: 0.5, y: 0)
        
        layer.endPoint = isVertical
            ? CGPoint (x: 1, y: 0.5)
            : CGPoint (x: 0.5, y: 1)
    }
}
