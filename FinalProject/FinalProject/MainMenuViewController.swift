//
//  MainMenuViewController.swift
//  FinalProject
//
//  Created by Jacob Grant on 5/6/19.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var backgroundMusicPlayer:AVAudioPlayer?

class MainMenuViewController : UIViewController {
    override func viewDidLoad() {
        if backgroundMusicPlayer == nil {
            let backgroundMusic = Bundle.main.url(forResource: "dox-unknown-energy", withExtension: "mp3")
            do {
                try backgroundMusicPlayer = AVAudioPlayer(contentsOf: backgroundMusic!)
                backgroundMusicPlayer!.numberOfLoops = 100
                backgroundMusicPlayer!.prepareToPlay()
                backgroundMusicPlayer!.play()
            } catch {
                print("Music Loading Error")
            }
        } else {
            backgroundMusicPlayer?.play()
        }
    }
}
