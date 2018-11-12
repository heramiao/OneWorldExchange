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
import os.log

class GroupListingViewController: BaseTableViewController, GroupSettingsControllerDelegate {
    
    // MARK: - Properties
    var groups = [Group]()
    
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // Again set up the stack to interface with CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groups")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                self.loadGroups(data: data)
                print(data.value(forKey: "title") as! String)
            }
        } catch {
            print("Failed")
        }
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
    
    func loadGroups(data: NSManagedObject){
        var newGroup = Group()
        newGroup.title = (data.value(forKey: "title") as! String)
        newGroup.startDate = (data.value(forKey: "start_date") as! Date)
        newGroup.endDate = (data.value(forKey: "end_date") as? Date)
        if let safeUnwrap = data.value(forKey: "picture") {
            newGroup.image = UIImage(data:(safeUnwrap as! NSData) as Data, scale:1.0)
        }
        groups.append(newGroup)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroup" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let group = groups[indexPath.row]
                (segue.destination as! GroupHomeViewController).detailItem = group
            }
        } else if segue.identifier == "addGroup" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! GroupSettingsController
            //controller.doneBarButton.isEnabled = false
            controller.delegate = self
        }
    }
    
    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath as IndexPath) as! GroupTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let group = groups[indexPath.row]
        os_log("The title of the group is: %@", group.title)
        os_log("The start date is: %@", dateFormatter.string(for: group.startDate)!)
        os_log("The end date is: %@", dateFormatter.string(for: group.endDate)!)
        
        cell.groupTitle!.text = group.title
        //      cell.groupTitle!.text = "group.title"
        cell.groupImage!.image = group.image
        cell.tripStartDate!.text = dateFormatter.string(for: group.startDate)
        cell.tripEndDate!.text = dateFormatter.string(for: group.endDate)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groups")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    // if the contact we are deleting is the same as this one in CoreData {
                    context.delete(data)
                    try context.save()
                }
            } catch {
                print("Failed")
            }
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showGroup", sender: tableView)
    }
    
    // MARK: - Delegate protocols
    func groupSettingsControllerDidCancel(controller: GroupSettingsController) {
        dismiss(animated: true, completion: nil)
    }
    
    func groupSettingsController(controller: GroupSettingsController, didFinishCreatingGroup group: Group) {
        let newRowIndex = groups.count
        
        groups.append(group)
        
        let indexPath = NSIndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
}
