//
//  CreditsViewController.swift
//  HoldOut
//
//  Created by Adam Chisolm on 7/30/19.
//  Copyright © 2019 Adam Chisolm. All rights reserved.
//

import UIKit
import SafariServices

class CreditsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        // Need to find out how to do this...
        showSafariVC(url: "https://adamchisolm.com")
    }
    
    @IBAction func gitHubButtonPressed(_ sender: UIButton) {
        showSafariVC(url: "https://github.com/achisolm/HoldOut")
    }
    
    func showSafariVC(url: String) {
        guard let myURL = URL(string: url) else {
            // Show error message
            return
        }
        
        let safariVC = SFSafariViewController(url: myURL)
        present(safariVC, animated: true)
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
