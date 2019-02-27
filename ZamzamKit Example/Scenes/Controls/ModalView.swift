//
//  ModalView.swift
//  ZamzamKit Example
//
//  Created by Basem Emara on 2018-12-06.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import UIKit
import ZamzamKit

protocol ModalViewDelegate: class {
    func modalViewDidApply()
}

class ModalView: UIView, PresentableView {

    @IBOutlet weak var contentView: UIView!
    
    weak var delegate: (UIViewController & ModalViewDelegate)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss self when tapped on background
        dismiss()
    }
    
    @IBAction func applyButtonTapped() {
        delegate?.modalViewDidApply()
        dismiss()
    }
    
    @IBAction func closeButtonTapped() {
        dismiss()
    }
}
