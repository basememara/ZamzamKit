//
//  ViewController.swift
//  ZamzamKit
//
//  Created by Basem Emara on 06/09/2015.
//  Copyright (c) 06/09/2015 Basem Emara. All rights reserved.
//

import UIKit
import ZamzamKit

class ViewController: UIViewController {

    let zamzamManager = ZamzamManager()
    
    @IBOutlet var inputText: UITextField!
    @IBOutlet var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    @IBAction func processTapped(sender: AnyObject) {
        outputLabel.text = ZamzamConfig.getArrayValue(inputText.text)[2]
    }
    
}

