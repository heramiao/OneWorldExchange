//
//  User.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/1/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

class User: NSObject {
  var id: Int
  var firstName: String
  var lastName: String
  var name: String
  var email: String
  var phone: String
  //var password: String
  //var passwordConfirmation: String
  var baseCurrency: String?
  var balance: Double
  
  init(id: Int, firstName: String, lastName: String, email: String, phone: String, baseCurrency: String, balance: Double) {
    // password: String, passwordConfirmation: String,
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.name = firstName + " " + lastName
    self.email = email
    self.phone = phone
    //self.password = password
    //self.passwordConfirmation = passwordConfirmation
    self.baseCurrency = baseCurrency
    self.balance = balance
  }
  
  //init(_ x: Any) { }
  
  static func getUser(_ userID: Int) -> User? {
    let userURL: NSURL = NSURL(string: "https://oneworldexchange.herokuapp.com/users/\(userID)")!
    let data = NSData(contentsOf: userURL as URL)!
    let swiftyjson = try! JSON(data: data as Data)
    
    let id = swiftyjson["id"].intValue
    let fname = swiftyjson["first_name"].stringValue
    let lname = swiftyjson["last_name"].stringValue
    let email = swiftyjson["email"].stringValue
    let phone = swiftyjson["phone"].stringValue
    let baseCurrency = swiftyjson["base_currency"].stringValue
    let balance = swiftyjson["balance"].doubleValue
    // let password = swiftyjson["password"].stringValue
    // let passwordConfirmation = swiftyjson["password_confirmation"].stringValue
    
    let user = User(id: id, firstName: fname, lastName: lname, email: email, phone: phone, baseCurrency: baseCurrency, balance: balance)
    // password: password, passwordConfirmation: passwordConfirmation,
    
    return user
  }
  
}

