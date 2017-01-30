//
//  Audible.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/25/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import UIKit
import AVFoundation

public protocol Audible: class {
    
    var audioPlayer: AVAudioPlayer? { get set }
    
}

public extension Audible {
    
    func setupAudioPlayer(_ application: UIApplication, fileName: String) {
        let sound = Bundle.main.url(forResource: fileName, withExtension: nil)
        
        guard audioPlayer == nil || audioPlayer?.url != sound else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            application.beginReceivingRemoteControlEvents()
            
            audioPlayer = try AVAudioPlayer(contentsOf: sound!)
            audioPlayer?.prepareToPlay()
        } catch { }
        
    }
    
}
