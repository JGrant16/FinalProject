//
//  HighscoreViewController.swift
//  FinalProject
//
//  Created by Joshua Sun on 2019/4/27.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController {
    
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
    
    @IBOutlet var names: [UILabel]!
    @IBOutlet var scores: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nameList = UserDefaults.standard.array(forKey: "name"), let scoreList = UserDefaults.standard.array(forKey: "score") {
            for i in 0..<10 {
                names[i].text = nameList[i] as? String
                scores[i].text = String(scoreList[i] as! Int)
            }
        } else {
            for i in 0..<10 {
                names[i].text = defaultLeaderboard[i].0
                scores[i].text = String(defaultLeaderboard[i].1)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
