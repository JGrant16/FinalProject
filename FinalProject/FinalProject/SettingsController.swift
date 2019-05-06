//
//  SettingsController.swift
//  FinalProject
//
//  Created by Joshua Sun on 2019/4/27.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var difficulties: UISegmentedControl!
    @IBOutlet weak var blueShip: UIButton!
    @IBOutlet weak var blackShip: UIButton!
    @IBOutlet weak var greenShip: UIButton!
    @IBOutlet weak var purpleShip: UIButton!
    
    @IBAction func selectBlueShip(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "shipColor")
        blueShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        blackShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        greenShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        purpleShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
    }
    
    @IBAction func selectBlackShip(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "shipColor")
        blackShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        blueShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        greenShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        purpleShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
    }
    
    @IBAction func selectGreenShip(_ sender: Any) {
        UserDefaults.standard.set(2, forKey: "shipColor")
        greenShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        blueShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        blackShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        purpleShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
    }
    
    @IBAction func selectPurpleShip(_ sender: Any) {
        UserDefaults.standard.set(3, forKey: "shipColor")
        purpleShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        blueShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        greenShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
        blackShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.0)
    }
    
    
    @IBAction func changeDifficulties(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(difficulties.selectedSegmentIndex, forKey: "difficulty")
    }
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        difficulties.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "difficulty")
        switch UserDefaults.standard.integer(forKey: "shipColor") {
        case 0:
            blueShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        case 1:
            blackShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        case 2:
            greenShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        case 3:
            purpleShip.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
        default:
            print("Incorrect Ship")
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
