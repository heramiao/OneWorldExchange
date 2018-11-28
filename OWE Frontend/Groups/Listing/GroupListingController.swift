//
//  GroupListingViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import CoreData
import Photos
import UIKit

class GroupListingController: BaseTableViewController, AddGroupDelegate {
 // , GroupSettingsControllerDelegate
  
  // MARK: - Outlets
  @IBOutlet weak var groupListingTable: UITableView!
    
  // MARK: - Properties
  let viewModel = GroupTripViewModel()
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    addSlideMenuButton()
    
    //        self.navigationItem.leftBarButtonItem = self.editButtonItem
    tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "onegroup")
    
    viewModel.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.groupListingTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_groups")
    
//    // Again set up the stack to interface with CoreData
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groups")
//    request.returnsObjectsAsFaults = false
//    do {
//      let result = try context.fetch(request)
//      for data in result as! [NSManagedObject] {
//        self.loadGroups(data: data)
//        print(data.value(forKey: "title") as! String)
//      }
//    } catch {
//      print("Failed")
//    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let selectedRow = tableView.indexPathForSelectedRow {
          tableView.deselectRow(at: selectedRow, animated: true)
      }
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
//  func loadGroups(data: NSManagedObject){
//      var newGroup = Group()
//      newGroup.title = (data.value(forKey: "title") as! String)
//      newGroup.startDate = (data.value(forKey: "start_date") as! Date)
//      newGroup.endDate = (data.value(forKey: "end_date") as? Date)
//      if let safeUnwrap = data.value(forKey: "picture") {
//          newGroup.image = UIImage(data:(safeUnwrap as! NSData) as Data, scale:1.0)
//      }
//      groups.append(newGroup)
//  }
  
  // MARK: - Table View
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let group: Group
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "onegroup", for: indexPath) as! GroupTableViewCell
    group = viewModel.groups[indexPath.row]
    //cell.groupImage.image = group.image
    cell.groupTitle!.text = group.tripName
    cell.tripStartDate.text = dateFormatter.string(for: group.startDate)
    cell.tripEndDate.text = dateFormatter.string(for: group.endDate)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//      if editingStyle == .delete {
//          let appDelegate = UIApplication.shared.delegate as! AppDelegate
//          let context = appDelegate.persistentContainer.viewContext
//          let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groups")
//          request.returnsObjectsAsFaults = false
//          do {
//              let result = try context.fetch(request)
//              for data in result as! [NSManagedObject] {
//                  // if the contact we are deleting is the same as this one in CoreData {
//                  context.delete(data)
//                  try context.save()
//              }
//          } catch {
//              print("Failed")
//          }
//          groups.remove(at: indexPath.row)
//          tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
//      }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      self.performSegue(withIdentifier: "showGroup", sender: tableView)
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showGroup" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        (segue.destination as! GroupHomeController).group = viewModel.groups[indexPath.row]
      }
    } else if segue.identifier == "addGroup" {
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! GroupSettingsController
        //controller.doneBarButton.isEnabled = false
        controller.addDelegate = self as AddGroupDelegate
        controller.segue = "addGroup"
    }
  }
  
  // MARK: - Delegate protocols
  func AddGroupCancel(controller: GroupSettingsController) {
      dismiss(animated: true, completion: nil)
  }

  func AddGroupSave(controller: GroupSettingsController, didFinishAddingGroup group: Group, newMembers: [User], segue: String) {
    
  }
}
