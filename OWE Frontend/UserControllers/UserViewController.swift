//
//  UserViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/31/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

let userURL: NSURL = NSURL(string: "https://oneworldexchange.herokuapp.com/user/1")!
let data = NSData(contentsOf: userURL as URL)!
let json = try! JSON(data: data as Data)

class UserViewController: UIViewController, UserSettingsDelegate {
  
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
    
    if let user = getUser(swiftyjson: json) {
      name.text = user.firstName + user.lastName
      email.text = user.email
      phone.text = user.phone
    }
    
  }
  
  func getUser(swiftyjson: JSON) -> User? {
    
    let fname = swiftyjson["first_name"].stringValue
    let lname = swiftyjson["last_name"].stringValue
    let email = swiftyjson["email"].stringValue
    let phone = swiftyjson["phone"].stringValue
    let password = swiftyjson["password"].stringValue
    let passwordConfirmation = swiftyjson["password_confirmation"].stringValue
    let baseCurrency = swiftyjson["base_currency"].stringValue
    
    let user = User(firstName: fname, lastName: lname, email: email, phone: phone, password: password, passwordConfirmation: passwordConfirmation, baseCurrency: baseCurrency)
    
    return user
  }
  
  func UserSettingsCancel(controller: UserSettingsViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func UserSettingsSave(controller: UserSettingsViewController, didFinishAddingSettings user: User) {
    // send post request
    // call view did load 
  }
    

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserSettings" {
      let showUserSettings:UserSettingsViewController = segue.destination as! UserSettingsViewController
      showUserSettings.profile = self.user
      
      showUserSettings.delegate = self as UserSettingsDelegate
    }
  }
  

}
