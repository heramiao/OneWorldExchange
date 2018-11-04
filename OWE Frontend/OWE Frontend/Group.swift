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
    var users: [User]
    var title: String
    var image: UIImage
    var startDate: Date
    var endDate: Date
    
    init(title: String, image: UIImage, users: [User], startDate: Date, endDate: Date) {
        self.users = users
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.image = image
    }
}
