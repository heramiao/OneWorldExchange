//
//  GroupSettingsViewModel.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/15/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

class GroupSettingsViewModel {
  
  let client = SearchClient()
  var users = [User]()
  
  let url = "https://oneworldexchange.herokuapp.com/user"
  
  func refresh(_ completion: @escaping () -> Void) {
    client.fetchRepositories ({ [unowned self] data in
      if let allUsers = self.repositoriesFromSearchResponse(data) {
        self.users = allUsers
      }
      completion()
    }, urlString: url)
  }
  
  func numberOfRows() -> Int {
    if users.isEmpty {
      return users.count
    } else {
      return users.count
    }
  }
  
  func nameForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < users.count else {
      return ""
    }
    if users.isEmpty {
      return users[indexPath.row].name
    } else {
      return users[indexPath.row].name
    }
  }
  
  func parseDictionary(_ data: Data?) -> [AnyObject]? {
    do {
      if let data = data,
      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
        return json
      }
    } catch {
      print("Couldn't parse JSON. Error: \(error)")
    }
    return nil
  }

  func repositoriesFromSearchResponse(_ data: Data?) -> [User]? {
    guard let dict = parseDictionary(data) else {
      print("Error: couldn't parse dictionary from data")
      return nil
    }

    return dict.compactMap { parseRepository($0) }
  }
  
  func parseRepository(_ dict: AnyObject) -> User? {
    if let id = dict["id"] as? Int,
      let fname = dict["first_name"] as? String,
      let lname = dict["last_name"] as? String,
      let email = dict["email"] as? String,
      let phone = dict["phone"] as? String,
      let password = dict["password"] as? String,
      let baseCurr = dict["base_currency"] as? String {
      let user = User(id: id, firstName: fname, lastName: lname, email: email, phone: phone, password: password, baseCurrency: baseCurr)
      return user
    } else {
      print("Error: couldn't parse JSON dictionary: \(dict)")
    }
    return nil
  }
  
}
