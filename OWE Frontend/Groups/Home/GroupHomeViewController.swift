//
//  GroupHomeViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GroupHomeViewController: UIViewController, GroupSettingsControllerDelegate {
  
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet var youOweTable: UITableView!
  @IBOutlet var newTransactionButton: UIButton!
  
  var group: Group?
  let viewModelMembers = GroupUsersViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //addSlideMenuButton()
    self.navigationItem.title = group!.tripName
//    if let tripImage = group.tripImage {
//      tripImage.image = group.image
//    }
    
    viewModelMembers.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.group!.members = self.viewModelMembers.users
        print(self.group!.members.count)
        // update wherever user contact photo is added
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_group/\(group!.id)/members")
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func groupSettingsCancel(controller: GroupSettingsController) {
    dismiss(animated: true, completion: nil)
  }
  
  func groupSettingsSave(controller: GroupSettingsController, didFinishChangingGroup group: Group) {
    // send update/patch request
    let params = [
      "id": group.id,
      "trip_name": group.tripName,
      "start_date": group.startDate,
      "end_date": group.endDate,
      ] as [String : Any]
    
    Alamofire.request("https://oneworldexchange.herokuapp.com/travel_groups/1", method: .patch, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData{ response in
      
      print(response)
      if let status = response.response?.statusCode {
        print(status)
      }
      if let result = response.result.value {
        print(result)
      }
    }
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editGroup" {
        let navController = segue.destination as! UINavigationController
        let controller = navController.topViewController as! GroupSettingsController
        controller.group = self.group
    }
  }

}
