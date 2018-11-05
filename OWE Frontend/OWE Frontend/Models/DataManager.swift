//
//  DataManager.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/5/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

class Datamanager {
    var groups = [Group]()
    var user = User()
    let backend: NSURL = NSURL(string: "https://dry-beyond-68805.herokuapp.com")!
    
    init() {
      loadGroups()
    }
    
    func loadGroups() {
        
        var results = [(key: AnyObject, value: AnyObject)]()
    }
    
    func getGroups() {
        let data = NSData(contentsOf: backend as URL)!
        let swiftyjson = try JSON(data: data as Data)
        
        if let temp_data = swiftyjson["main"]["temp"].float {
            print("Temp is: \(temp_data)")
        }
    }
    
    func saveGroups() {
        
    }
}
