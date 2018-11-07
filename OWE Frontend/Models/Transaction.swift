//
//  Transaction.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/6/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

class Transaction {
  var dateCharged: Date
  var description: String
  var currencyType: String
  var totalCharged: Float
  var country: String
  var expenseType: String
  var groupID: Int
  
  init(dateCharged: Date, description: String, currencyType: String, totalCharged: Float, country: String, expenseType: String, groupID: Int) {
    self.dateCharged = dateCharged
    self.description = description
    self.currencyType = currencyType
    self.totalCharged = totalCharged
    self.country = country
    self.expenseType = expenseType
    self.groupID = groupID
  }
}
