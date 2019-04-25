//
//  GameViewController.swift
//  FinalProject
//
//  Created by Jacob Grant on 4/16/19.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var currScene: GameScene?;

    @IBAction func leaveGame(_ sender: UIButton) {
        // Should kill the current scene, otherwise it will become laggy after a few plays.
        currScene!.isPaused = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            currScene = scene
                
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
