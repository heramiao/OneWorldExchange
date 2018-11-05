//
//  UserViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/31/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
  
  var user: User?
  
  // MARK: - Outlets
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var phone: UILabel!
  
  @IBOutlet weak var yourHoldings: UILabel!
  @IBOutlet weak var youOwe: UILabel!
  @IBOutlet weak var youreOwed: UILabel!
  
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var friendsButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let user = getUser() {
      name.text = user.firstName + user.lastName
      email.text = user.email
      phone.text = user.phone
    }
    
  }
    

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserSettings" {
      let showUserSettings:UserSettingsViewController = segue.destination as! UserSettingsViewController
      showUserSettings.profile = self.user
    }
  }
  

}
