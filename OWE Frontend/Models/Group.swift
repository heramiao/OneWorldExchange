//
//  Group.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

class Group {
    
  // MARK: - Properties
  var id: Int
  var tripName: String
  var startDate: Date
  var endDate: Date
  var image: UIImage?
  var members = [User]()
  
  init(id: Int, tripName: String, startDate: Date, endDate: Date, members: [User]) {
    self.id = id
    self.tripName = tripName
    self.startDate = startDate
    self.endDate = endDate
    self.members = members 
  }
  
}
