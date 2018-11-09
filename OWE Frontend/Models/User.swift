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
  var id: Int
  var firstName: String
  var lastName: String
  var email: String
  var phone: String
  var password: String
  var passwordConfirmation: String
  var baseCurrency: String
  
  init(id: Int, firstName: String, lastName: String, email: String, phone: String, password: String, passwordConfirmation: String, baseCurrency: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.phone = phone
    self.password = password
    self.passwordConfirmation = passwordConfirmation
    self.baseCurrency = baseCurrency
  }
  
}

