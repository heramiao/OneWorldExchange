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

class GroupHomeController: UIViewController, EditGroupDelegate, NewTransactionDelegate {
  
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet var youOweTable: UITableView!
  
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
        // update wherever user contact photo is added
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_group/\(group!.id)/members")
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func EditGroupCancel(controller: GroupSettingsController) {
    dismiss(animated: true, completion: nil)
  }
  
  func EditGroupSave(controller: GroupSettingsController, didFinishEditingGroup group: Group, newMembers: [User]) {
    // send update/patch request
    for member in newMembers {
      let paramsMember = [
        "travel_group_id": group.id,
        "user_id": member.id
      ]
      
      Alamofire.request("https://oneworldexchange.herokuapp.com/group_members", method: .post, parameters: paramsMember, encoding: JSONEncoding.default, headers: nil).responseData{ response in
        
        print(response)
        if let status = response.response?.statusCode {
          print(status)
        }
        if let result = response.result.value {
          print(result)
        }
      }
    }
    
    let paramsGroup = [
      "id": group.id,
      "trip_name": group.tripName,
      "start_date": group.startDate,
      "end_date": group.endDate,
    ] as [String : Any]
    
    Alamofire.request("https://oneworldexchange.herokuapp.com/travel_groups/1", method: .patch, parameters: paramsGroup, encoding: JSONEncoding.default, headers: nil).responseData{ response in
      
      print(response)
      if let status = response.response?.statusCode {
        print(status)
      }
      if let result = response.result.value {
        print(result)
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  func NewTransactionCancel(controller: TransactionController) {
    dismiss(animated: true, completion: nil)
  }
  
  func NewTransactionSave(controller: TransactionController, didFinishCreatingTransaction transaction: Transaction) {
    
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editGroup" {
      let navController = segue.destination as! UINavigationController
      let controller = navController.topViewController as! GroupSettingsController
      controller.group = self.group
      controller.segue = "editGroup"
      controller.editDelegate = self as EditGroupDelegate
    }
    if segue.identifier == "newTransaction" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! TransactionController
      controller.group = self.group
      controller.delegate = self as NewTransactionDelegate
    }
  }

}
