//
//  LoginViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 12/6/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var username: UITextField!

  @IBAction func login(sender: UIButton!) {
    performSegue(withIdentifier: "login", sender: self)
  }
  
  var user: User?
  let delegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // addSlideMenuButton()
    
    if let user = delegate.user {
      self.user = user
    } else {
      self.user = User.getUser(1)
      delegate.user = self.user
    }

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "login" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! GroupListingController
      controller.user = self.user
    }
  }
  
}
