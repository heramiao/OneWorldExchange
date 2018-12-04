//
//  TransactionViewModel.swift
//  OWE Frontend
//
//  Created by Hera Miao on 12/3/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

class TransactionViewModel {
  
//  var symbols = [
//    "AUD": ["$", 1.3702790739],
//    "CAD": ["$", 1.3307509464],
//    "CHF": ["CHF", 0.9983273175],
//    "CNY": ["¥", 6.9457698741],
//    "EUR": ["€", 0.8803591865],
//    "GBP": ["£", 0.7841183203],
//    "JPY": ["¥", 113.5575314728],
//    "MXN": ["$", 20.3283739766],
//    "SEK": ["kr", 9.0848666256],
//    "USD": ["$", 1.0]
//    ] as! [String : String]
  
  var symbols = [
    "AUD": "$",
    "CAD": "$",
    "CHF": "CHF",
    "CNY": "¥",
    "EUR": "€",
    "GBP": "£",
    "JPY": "¥",
    "MXN": "$",
    "SEK": "kr",
    "USD": "$"
  ] as! [String : String]
  
  var rates = [
    "AUD": 1.3702790739,
    "CAD": 1.3307509464,
    "CHF": 0.9983273175,
    "CNY": 6.9457698741,
    "EUR": 0.8803591865,
    "GBP": 0.7841183203,
    "JPY": 113.5575314728,
    "MXN": 20.3283739766,
    "SEK": 9.0848666256,
    "USD": 1.0
  ] as! [String : Double]

  
  func currToSymbol(currType: String) -> String {
    return symbols[currType]!
  }
  
  func convert(currAbrev: String, amount: String) -> String {
    let doubleAmt = Double(amount)
    let USDAmt: Double
    USDAmt = rates[currAbrev]! * doubleAmt!
    return String(USDAmt)
  }
  
}
