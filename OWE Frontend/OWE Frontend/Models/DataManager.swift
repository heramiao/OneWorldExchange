//
//  DataManager.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/5/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

// MARK: - String Extension

extension String {
  // CREDIT: IOS Development Lab 9
  
  // recreating a function that String class no longer supports in Swift 2.3
  // but still exists in the NSString class. (This trick is useful in other
  // contexts as well when moving between NS classes and Swift counterparts.)
  
  /**
   Returns a new string made by appending to the receiver a given string.  In this case, a new string
   made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
   
   - parameter aPath: The path component to append to the receiver. (String)
   - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
   
   */
  func stringByAppendingPathComponent(aPath: String) -> String {
    let nsSt = self as NSString
    return nsSt.appendingPathComponent(aPath)
  }
}

// MARK: - Data Manager Class

class DataManager {
  
  // MARK: - General
  
  var groups = [Group]()
  var user = User()
  let backendURL: NSURL = NSURL(string: "https://dry-beyond-68805.herokuapp.com")!
  
  init() {
    loadGroups()
  }
  
  // MARK: - Data Location Methods
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent(aPath: "Groups.plist")
  }
  
    
  // MARK: - Saving & Loading Data
    
  func loadGroups() {
    let path = dataFilePath()
    if FileManager.default.fileExists(atPath: path) {
        if let data = NSData(contentsOfFile: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            self.groups = unarchiver.decodeObject(forKey: "Groups") as! [Group]
            unarchiver.finishDecoding()
        } else {
            print("\nFILE NOT FOUND AT: \(path)")
        }
    }
  }
  
  func getGroups() {
    let data = NSData(contentsOf: backendURL as URL)!
    let swiftyjson = try? JSON(data: data as Data)
  
//    if let groups = swiftyjson[""][""].float {
//        print("\(groups)")
//    }
  }
  
  func saveGroups() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.encode(groups, forKey: "Groups")
    archiver.finishEncoding()
    data.write(toFile: dataFilePath(), atomically: true)
  }
}
