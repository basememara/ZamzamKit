//
//  Audible.swift
//  ZamzamCore
//
//  Created by Basem Emara on 3/25/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import AVFoundation
import Foundation.NSBundle
import Foundation.NSURL
import UIKit.UIApplication

public protocol Audible: AnyObject {
    var audioPlayer: AVAudioPlayer? { get set }
}

public extension Audible {
    /// Configures and plays audio from a file.
    ///
    /// - Parameters:
    ///   - url: A `URL` that identifies the local audio file to play.
    ///   - application: The application used to control the audio events.
    func play(contentsOf url: URL, application: AudibleApplication? = nil) throws {
        if audioPlayer == nil || audioPlayer?.url != url {
            if audioPlayer?.isPlaying == true {
                audioPlayer?.stop()
            }

            audioPlayer = try AVAudioPlayer(contentsOf: url)
        }

        if audioPlayer?.currentTime != 0 {
            audioPlayer?.currentTime = 0
        }

        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        application?.beginReceivingRemoteControlEvents()

        audioPlayer?.play()
    }
}

// MARK: - Types

public protocol AudibleApplication {
    func beginReceivingRemoteControlEvents()
}

extension UIApplication: AudibleApplication {}
#endif
