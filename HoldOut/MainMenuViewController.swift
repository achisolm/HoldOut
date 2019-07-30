//
//  MainMenuViewController.swift
//  HoldOut
//
//  Created by Adam Chisolm on 7/30/19.
//  Copyright © 2019 Adam Chisolm. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func playButtonPressed(_ sender: UIButton) {
        print("Play game")
    }
    
    @IBAction func istructionsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func creditsButtonPressed(_ sender: UIButton) {
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
