//
//  Group.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

class Group: NSObject, NSCoding {
    
    // MARK: - Properties
//    var users: [User]?
    var title: String
    var image: UIImage?
    var startDate: Date
    var endDate: Date
    
    // MARK: - General
    override init() {
        super.init()
    }
    
    // MARK: - Encoding
    required init(coder aDecoder: NSCoder) {
//        self.users = aDecoder.decodeObject(forKey: "users") as? [User]
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as? UIImage
        self.startDate = aDecoder.decodeObject(forKey: "start_date") as! Date
        self.endDate = aDecoder.decodeObject(forKey: "end_date") as! Date
        super.init()
    }
    
//    initialize 
//    init(title: String, image: UIImage, users: [User], startDate: Date, endDate: Date) {
//        self.users = users
//        self.title = title
//        self.startDate = startDate
//        self.endDate = endDate
//        self.image = image
//    }
    
    func encode(with aCoder: NSCoder) {
//        aCoder.encode(users, forKey: "users")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(startDate, forKey: "start_date")
        aCoder.encode(endDate, forKey: "end_date")
    }
    
}
