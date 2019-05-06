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

    @IBOutlet weak var restartButton: UIButton!
    
    var currScene: GameScene?

    let defaultLeaderboard: [(String, Int)] =
    [
        ("Ultraplayer", 100),
        ("Megaplayer", 90),
        ("Superplayer", 80),
        ("Veteran", 70),
        ("Professional", 60),
        ("Experienced", 50),
        ("Advanced", 40),
        ("Normal", 30),
        ("Novice", 20),
        ("Beginner", 10)
    ]
    
    @IBAction func restartGame(_ sender: UIButton) {
        saveHighscore()
    }
    
    @IBAction func leaveGame(_ sender: UIButton) {
        saveHighscore()
    }
    
    func saveHighscore() {
        
        var name: String = ""
        
        if currScene!.gameOverDetect {
            let score = currScene!.score
            var leaderboard: [(String, Int)] = []
            if let names = UserDefaults.standard.array(forKey: "name"), let scores = UserDefaults.standard.array(forKey: "score") {
                for i in 0..<10 {
                    leaderboard.append((names[i] as! String, scores[i] as! Int))
                }
            } else {
                leaderboard = defaultLeaderboard
            }
            if score >= leaderboard[9].1 {
                var uploadedNames : [String] = []
                var uploadedScores : [Int] = []
                
                for subView in view.subviews {
                    if subView is UITextField {
                        name = (subView as! UITextField).text ?? "Player"
                        if name == "" {
                            name = "Player"
                        }
                    }
                }
                
                let newScore = (name, score)
                var temp: (String, Int)?
                
                for i in 0..<10 {
                    if let last = temp {
                        temp = leaderboard[i]
                        leaderboard[i] = last
                    }
                    if temp == nil && score >= leaderboard[i].1 {
                        temp = leaderboard[i]
                        leaderboard[i] = newScore
                    }
                }
                
                print(leaderboard)
                for i in 0..<10 {
                    uploadedNames.append(leaderboard[i].0)
                    uploadedScores.append(leaderboard[i].1)
                }
                
                UserDefaults.standard.set(uploadedScores, forKey: "score")
                UserDefaults.standard.set(uploadedNames, forKey: "name")
                
            }
        }
        
        
        
        // Should kill the current scene, otherwise it will become laggy after a few plays.
        currScene!.isPaused = true
        currScene = nil
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            let backGround = SKSpriteNode(imageNamed: "Harris-Space-wallpaper")
            backGround.size = CGSize(width: view.frame.size.width, height: view.frame.size.height+100)
            backGround.position = CGPoint(x: view.frame.size.width, y: view.frame.midY)
            backGround.zPosition = ZPositions.backGround
            scene.backGround = backGround
            currScene = scene
            self.restartButton.isHidden = true
            scene.restartButton = self.restartButton
                
            view.presentScene(currScene)
            
            
            view.ignoresSiblingOrder = true
            
        }
    }
}
