//
//  Split.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/6/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

class Split {
  var payee: Int
  var payor: Int
  var percentOwed: Float
  var amountOwed: Float
  var datePaid: Date
  var transactionID: Int
  
  init(payee: Int, payor: Int, percentOwed: Float, amountOwed: Float, datePaid: Date, transactionID: Int) {
    self.payee = payee
    self.payor = payor
    self.percentOwed = percentOwed
    self.amountOwed = amountOwed
    self.datePaid = datePaid
    self.transactionID = transactionID
  }
}
