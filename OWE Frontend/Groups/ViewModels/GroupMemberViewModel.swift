//
//  GroupMembersViewModel.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/27/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import Alamofire

class GroupMemberViewModel {
  
//  typealias JSONDictionary = [String: AnyObject]
//  
//  let viewModelUsers = GroupUsersViewModel()
//  let client = SearchClient()
//  var groups = [Group]()
//  var members = [User]()
//  
//  func refresh(_ completion: @escaping () -> Void, url: String) {
//    client.fetchRepositories ({ [unowned self] data in
//      self.repositoriesFromSearchResponse(data)
//      completion()
//      }, urlString: url)
//  }
//  
//  func numberOfRows() -> Int {
//    if groups.isEmpty {
//      return groups.count
//    } else {
//      return groups.count
//    }
//  }
//  
//  func nameForRowAtIndexPath(_ indexPath: IndexPath) -> String {
//    guard indexPath.row >= 0 && indexPath.row < groups.count else {
//      return ""
//    }
//    if groups.isEmpty {
//      return groups[indexPath.row].tripName
//    } else {
//      return groups[indexPath.row].tripName
//    }
//  }
//  
//  func parseDictionary(_ data: Data?) -> [AnyObject]? {
//    do {
//      if let data = data,
//        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
//        return json
//      }
//    } catch {
//      print("Couldn't parse JSON. Error: \(error)")
//    }
//    return nil
//  }
//  
//  func repositoriesFromSearchResponse(_ data: Data?) {
//    //  -> [Group]?
//    guard let dict = parseDictionary(data) else {
//      print("Error: couldn't parse dictionary from data")
//      // return nil
//      return
//    }
//    
//    for elem in dict {
//      parseRepository(elem)
//    }
//    return
//  }
//  
//  func parseRepository(_ dict: AnyObject) {
//    // -> Group?
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    
//    if let id = dict["id"] as? Int,
//      let tripName = dict["trip_name"] as? String,
//      let start = dict["start_date"] as? String,
//      let end = dict["end_date"] as? String {
//      let startDate = dateFormatter.date(from: start)
//      let endDate = dateFormatter.date(from: end)
//      getMembers(id: id, tripName: tripName, startDate: startDate!, endDate: endDate!)
//    } else {
//      print("Error: couldn't parse JSON dictionary: \(dict)")
//    }
//    // return nil
//  }
//  
//  func getMembers(id: Int, tripName: String, startDate: Date, endDate: Date) {
//    let group = DispatchGroup()
//    group.enter()
//    
//    viewModelUsers.refresh ({ [unowned self] in
//      DispatchQueue.main.async {
//        self.members = self.viewModelUsers.users
//        group.leave()
//      }
//      }, url: "https://oneworldexchange.herokuapp.com/travel_group/\(id)/members")
//    
//    group.notify(queue: .main) {
//      //let group = Group(id: id, tripName: tripName, startDate: startDate, endDate: endDate, members: self.members)
//      self.groups.append(group)
//    }
//  }
  
}
