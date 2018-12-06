//
//  LoginViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 12/6/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

let userURL: NSURL = NSURL(string: "https://oneworldexchange.herokuapp.com/users/1")!
let data = NSData(contentsOf: userURL as URL)!
let json = try! JSON(data: data as Data)

class LoginViewController: UIViewController {
  
  @IBOutlet weak var username: UITextField!

  @IBAction func login(sender: UIButton!) {
    performSegue(withIdentifier: "login", sender: self)
  }
  
  var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // addSlideMenuButton()
    
    if let user = getUser(swiftyjson: json) {
      self.user = user
    } else {
      print("couldn't get user")
    }
  }
  
  func getUser(swiftyjson: JSON) -> User? {
    let id = swiftyjson["id"].intValue
    let fname = swiftyjson["first_name"].stringValue
    let lname = swiftyjson["last_name"].stringValue
    let email = swiftyjson["email"].stringValue
    let phone = swiftyjson["phone"].stringValue
    let baseCurrency = swiftyjson["base_currency"].stringValue
    // let password = swiftyjson["password"].stringValue
    // let passwordConfirmation = swiftyjson["password_confirmation"].stringValue
    
    let user = User(id: id, firstName: fname, lastName: lname, email: email, phone: phone, baseCurrency: baseCurrency)
    // password: password, passwordConfirmation: passwordConfirmation,
    
    return user
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "login" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! GroupListingController
      controller.user = self.user
    }
  }
  
}
