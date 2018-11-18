//
//  SearchClient.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/16/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import Alamofire

class SearchClient {
  func fetchRepositories(_ completion: @escaping (Data?) -> Void, urlString: String) {
    
    Alamofire.request(urlString).response { response in
      if let error = response.error {
        print("Error fetching repository data: \(error)")
        completion(response.data)
        return
      }
      completion(response.data)
    }
    
  }
}
