//
//  UserViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/31/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit
import Alamofire

let userURL: NSURL = NSURL(string: "https://oneworldexchange.herokuapp.com/users/1")!
let data = NSData(contentsOf: userURL as URL)!
let json = try! JSON(data: data as Data)

class UserViewController: BaseViewController, UserSettingsDelegate {
  
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
    addSlideMenuButton()
    
    if let user = getUser(swiftyjson: json) {
      self.user = user
      name.text = user.name
      email.text = user.email
      phone.text = user.phone
    } else {
      print("couldn't get user")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func getUser(swiftyjson: JSON) -> User? {
    let id = swiftyjson["id"].intValue
    let fname = swiftyjson["first_name"].stringValue
    let lname = swiftyjson["last_name"].stringValue
    let email = swiftyjson["email"].stringValue
    let phone = swiftyjson["phone"].stringValue
    let password = swiftyjson["password"].stringValue
    // let passwordConfirmation = swiftyjson["password_confirmation"].stringValue
    let baseCurrency = swiftyjson["base_currency"].stringValue
    
    let user = User(id: id, firstName: fname, lastName: lname, email: email, phone: phone, password: password, baseCurrency: baseCurrency)
    // passwordConfirmation: passwordConfirmation,
    
    return user
  }
  
  
  func UserSettingsCancel(controller: UserSettingsViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func UserSettingsSave(controller: UserSettingsViewController, didFinishAddingSettings user: User) {
    // send update/patch request
    let params = [
      "id": user.id,
      "first_name": user.firstName,
      "last_name": user.lastName,
      "email": user.email,
      "phone": user.phone,
      "password": user.password,
      // "password_confirmation": user.passwordConfirmation,
      "base_currency": user.baseCurrency
      ] as [String : Any]
    
    Alamofire.request("https://oneworldexchange.herokuapp.com/users/1", method: .patch, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData{ response in
      
      print(response)
      if let status = response.response?.statusCode {
        print(status)
      }
      if let result = response.result.value {
        print(result)
      }
    }
    
    dismiss(animated: true, completion: nil)
    
    self.user = user
    name.text = user.name
    email.text = user.email
    phone.text = user.phone
    
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserSettings" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! UserSettingsViewController
      controller.profile = self.user
      
      controller.delegate = self as UserSettingsDelegate
    }
  }
  
}
