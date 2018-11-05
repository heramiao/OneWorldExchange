//
//  User.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/1/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

let userURL: NSURL = NSURL(string: "https://oneworldexchange.herokuapp.com/user/1")!
let data = NSData(contentsOf: userURL as URL)!
let json = try? JSON(data: data as Data)

class User {
  var firstName: String
  var lastName: String
  var email: String
  var phone: String
  var password: String
  var passwordConfirmation: String
  var baseCurrency: String
  
  init(firstName: String, lastName: String, email: String, phone: String, password: String, passwordConfirmation: String, baseCurrency: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.phone = phone
    self.password = password
    self.passwordConfirmation = passwordConfirmation
    self.baseCurrency = baseCurrency
  }
  
}

func getUser(swiftyjson: JSON) -> User? {
  
  let fname = json["first_name"].stringValue
  let lname = json["last_name"].stringValue
  let email = json["email"].stringValue
  let phone = json["phone"].stringValue
  let password = json["password"].stringValue
  let passwordConfirmation = json["password_confirmation"].stringValue
  let baseCurrency = json["base_currency"].stringValue
  
  let user = User(firstName: fname, lastName: lname, email: email, phone: phone, password: password, passwordConfirmation: passwordConfirmation, baseCurrency: baseCurrency)
  
  return user
}
