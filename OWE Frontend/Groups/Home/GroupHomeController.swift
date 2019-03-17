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

extension Double {
  /// Rounds the double to decimal places value
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

class GroupHomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditGroupDelegate, NewTransactionDelegate, PaySplitDelegate {
  
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet var youOweTable: UITableView!
  
  var user: User?
  let delegate = UIApplication.shared.delegate as! AppDelegate
  
  var group: Group?
  var splits = [Split]()
  let viewModelMembers = GroupUsersViewModel()
  let userVC = UserController()
  let dateFormatter = DateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //addSlideMenuButton()
    
    if let user = delegate.user {
      self.user = user
    } else {
      self.user = User.getUser(1)
      delegate.user = self.user
    }
    
    self.navigationItem.title = group!.tripName
    if let image = group!.image {
      tripImage.image = group!.image
    }
    
    dateFormatter.dateFormat = "YYYY-MM-dd"
    
    let cellNib = UINib(nibName: "SplitsTableCell", bundle: nil)
    youOweTable.register(cellNib, forCellReuseIdentifier: "split")

    // use core data bc already updated in API
    viewModelMembers.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.group!.members = self.viewModelMembers.users
        // update wherever user contact photo is added
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_group/\(group!.id)/members")
    
    // Again set up the stack to interface with CoreData
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groups")
//    request.returnsObjectsAsFaults = false
//    do {
//      let result = try context.fetch(request)
//      for data in result as! [NSManagedObject] {
//        self.loadGroup(data: data)
//      }
//    } catch {
//      print("Failed")
//    }
    
    // Again set up the stack to interface with CoreData
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionSplit")
    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        self.loadSplit(data: data)
      }
    } catch {
      print("Failed")
    }
  }
  
  // using Core Data, update trip name and trip photo
//  func loadGroup(data: NSManagedObject){
//    self.navigationItem.title = data.value(forKey: "trip_name") as! String
//    self.tripImage.image = UIImage(data:(data.value(forKey: "picture") as! NSData) as Data, scale:1.0)
//  }
  
  func loadSplit(data: NSManagedObject) {
    let newSplit = Split()
    newSplit.payee = (data.value(forKey: "payee") as! User)
    print(data.value(forKey: "payee") as! User)
    newSplit.payor = (data.value(forKey: "payor") as! User)
    newSplit.datePaid = (data.value(forKey: "date_paid") as! String)
    newSplit.descript = (data.value(forKey: "descript") as! String)
    newSplit.currencyAbrev = data.value(forKey: "currency_abrev") as! String
    newSplit.currencySymb = (data.value(forKey: "currency_symb") as! String)
    newSplit.amountOwed = (data.value(forKey: "amount_owed") as! Double)
    newSplit.convertedAmt = (data.value(forKey: "converted_amt") as! Double)
    splits.append(newSplit)
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
    if split.payee == split.payor {
      // if split is for me, charge myself and don't add row to table
      if split.payee!.id == self.user?.id {
        delegate.user!.balance = ((delegate.user?.balance)! - split.convertedAmt!).rounded(toPlaces: 2)
        // if split is for someone else to themselves, don't add to table
        return
      } else {
        return
      }
    }
    
    let newRowIndex = splits.count
    
    splits.append(split)
    
    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    youOweTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
  }
  
  func paySplit(cell: SplitsTableCell, payor: User, amountOwed: String, indexPath: Int) {
    let amtOwed = Double(amountOwed)
    if payor.id == self.user!.id {
      user!.balance = user!.balance - amtOwed!
      delegate.user!.balance = user!.balance
    
      splits.remove(at: indexPath)
      self.youOweTable.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
    }
  }
  
  // MARK: - Table View
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return splits.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let split: Split
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "split", for: indexPath) as! SplitsTableCell
    split = splits[indexPath.row]
    cell.delegate = self as PaySplitDelegate
    cell.indexPath = indexPath.row
    cell.payor = split.payor!
    cell.payorName!.text = split.payor!.firstName
    cell.payeeName!.text = split.payee!.firstName
    cell.date!.text = split.datePaid
    cell.descript!.text = split.descript
    cell.orgCurrSymbol!.text = split.currencySymb
    cell.orgAmt!.text = String(split.amountOwed!)
    // cell.baseCurrSymbol!.text = get the base currency of payor
    cell.convertedAmt!.text = String(split.convertedAmt!)
    cell.amountOwed = cell.convertedAmt!.text
    
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
