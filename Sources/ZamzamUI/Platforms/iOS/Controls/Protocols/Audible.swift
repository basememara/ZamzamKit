//
//  Audible.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/25/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import AVFoundation

public protocol Audible: class {
    var audioPlayer: AVAudioPlayer? { get set }
}

public extension Audible {
    
    func setupAudioPlayer(_ application: UIApplication, forResource fileName: String, bundle: Bundle = .main) {
        guard let sound = bundle.url(forResource: fileName, withExtension: nil),
            (audioPlayer == nil || audioPlayer?.url != sound) else {
                return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            application.beginReceivingRemoteControlEvents()
            
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer?.prepareToPlay()
        } catch {
            
        }
    }
}

public extension Audible {
    
    func setupAudioPlayer(_ application: UIApplication, forAsset assetName: String, type: String? = nil, bundle: Bundle = .main) {
        guard let sound = NSDataAsset(name: assetName, bundle: bundle)?.data,
            (audioPlayer == nil || audioPlayer?.data != sound) else {
                return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            application.beginReceivingRemoteControlEvents()
            
            audioPlayer = try AVAudioPlayer(data: sound, fileTypeHint: type)
            audioPlayer?.prepareToPlay()
        } catch {
            
        }
    }
}
#endif
