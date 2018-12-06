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
  
}
