//
//  User.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/1/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

class User {
  var id: Int
  var firstName: String
  var lastName: String
  var name: String
  var email: String
  var phone: String
  var password: String
  // var passwordConfirmation: String
  var baseCurrency: String
  
  init(id: Int, firstName: String, lastName: String, email: String, phone: String, password: String, baseCurrency: String) {
    // passwordConfirmation: String, add to init
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.name = firstName + " " + lastName
    self.email = email
    self.phone = phone
    self.password = password
    // self.passwordConfirmation = passwordConfirmation
    self.baseCurrency = baseCurrency
  }
  
}

