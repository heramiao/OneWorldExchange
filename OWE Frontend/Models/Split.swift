//
//  Split.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/6/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit
import Foundation

class Split: NSObject {
  var payee: User?
  //var payee: Int --> for the user id
  var payor: User?
  // var payor: Int
  var datePaid: String?
  // var datePaid: Date
  var descript: String?
  var currencyAbrev: String?
  var currencySymb: String?
  var amountOwed: Double?
  //var amountOwed: Float
  var convertedAmt: Double?
  //var transactionID: Int
  
//  init(payee: String, payor: String, description: String, currency: String, amountOwed: String, datePaid: String) {
//    self.payee = payee
//    self.payor = payor
//    self.description = description
//    // self.percentOwed = percentOwed
//    self.currency = currency
//    self.amountOwed = amountOwed
//    self.datePaid = datePaid
//    //self.transactionID = transactionID
//  }

  override init() {
    super.init()
  }
}
