//
//  UserViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/31/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit
import Alamofire

class UserController: BaseController, UserSettingsDelegate {
  
  var user: User?
  let delegate = UIApplication.shared.delegate as! AppDelegate
  
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
    
    if let user = delegate.user {
      self.user = user
    } else {
      self.user = User.getUser(1)
      delegate.user = self.user
    }
    
    name.text = user!.name
    email.text = user!.email
    phone.text = user!.phone
    yourHoldings.text = String(user!.balance)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func UserSettingsCancel(controller: UserSettingsController) {
    dismiss(animated: true, completion: nil)
  }
  
  func UserSettingsSave(controller: UserSettingsController, didFinishAddingSettings user: User) {
    // send update/patch request
    let params = [
      "id": user.id,
      "first_name": user.firstName,
      "last_name": user.lastName,
      "email": user.email,
      "phone": user.phone,
      "base_currency": user.baseCurrency,
      "balance": user.balance
      // "password": user.password,
      // "password_confirmation": user.passwordConfirmation,
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
    
    //self.user = user
    //name.text = user.name
    name.text = user.firstName + " " + user.lastName
    email.text = user.email
    phone.text = user.phone
    yourHoldings.text = String(user.balance)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserSettings" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! UserSettingsController
      controller.profile = self.user
      
      controller.delegate = self as UserSettingsDelegate
    }
  }
  
}
