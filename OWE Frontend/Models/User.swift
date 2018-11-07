//
//  User.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/1/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
//import SwiftyJSON

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

