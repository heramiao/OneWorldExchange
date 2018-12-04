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
import CoreData

class GroupHomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditGroupDelegate, NewTransactionDelegate {
  
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet var youOweTable: UITableView!
  
  var group: Group?
  var splits = [Split]()
  let viewModelMembers = GroupUsersViewModel()
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //addSlideMenuButton()
    self.navigationItem.title = group!.tripName
    if let image = group!.image {
      tripImage.image = group!.image
    }
    
    dateFormatter.dateFormat = "YYYY-MM-dd"
    
    let cellNib = UINib(nibName: "SplitsTableCell", bundle: nil)
    youOweTable.register(cellNib, forCellReuseIdentifier: "split")
    
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
      "start_date": dateFormatter.string(from: group.startDate),
      "end_date": dateFormatter.string(from: group.endDate),
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
    
    self.navigationItem.title = group.tripName
    tripImage.image = group.image
  }
  
  func NewTransactionCancel(controller: TransactionController) {
    dismiss(animated: true, completion: nil)
  }
  
  func NewTransactionSave(controller: TransactionController, didFinishCreatingSplit split: Split) {
    let newRowIndex = splits.count
    
    splits.append(split)
    
    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    youOweTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Table View
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return splits.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let split: Split
    let transactionVM = TransactionViewModel()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "split", for: indexPath) as! SplitsTableCell
    split = splits[indexPath.row]
    
    let payorFName = split.payor!.components(separatedBy: " ")
    let payeeFName = split.payee!.components(separatedBy: " ")
    
    cell.payorName!.text = payorFName[0]
    cell.payeeName!.text = payeeFName[0]
    cell.date!.text = split.datePaid
    cell.descript!.text = split.descript
    cell.orgCurrSymbol!.text = split.currencySymb
    cell.orgAmt!.text = split.amountOwed
    // cell.baseCurrSymbol!.text = get the base currency of payor
    cell.convertedAmt!.text = transactionVM.convert(currAbrev: split.currencyAbrev!, amount: split.amountOwed!)
    
    if cell.payorName!.text != "Hera" {
      cell.payBtn!.isHidden = true
    }
    
    return cell
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
