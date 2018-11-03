//
//  UserViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/31/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
  
  let user = User()
  
  // MARK: - Outlets
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var phone: UILabel!
  
  @IBOutlet weak var yourHoldings: UILabel!
  @IBOutlet weak var youOwe: UILabel!
  @IBOutlet weak var youreOwed: UILabel!
  
  @IBOutlet weak var userSettingsButton: UIBarButtonItem!
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var friendsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showUserSettings" {
        let showUserSettings:UserSettingsViewController = segue.destination as! UserSettingsViewController
        showUserSettings.user = self.user
      }
    }
  

}
