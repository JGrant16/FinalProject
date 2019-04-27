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
    
    @IBAction func changeDifficulties(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(difficulties.selectedSegmentIndex, forKey: "difficulty")
    }
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        difficulties.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "difficulty")
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
