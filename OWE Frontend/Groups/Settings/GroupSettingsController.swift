//  GroupSettingsViewController.swift
//  OWE Frontend

import Foundation
import CoreData
import Photos
import UIKit

// MARK: Protocol Methods
protocol EditGroupDelegate: class {
  func EditGroupCancel(controller: GroupSettingsController)
  func EditGroupSave(controller: GroupSettingsController, didFinishEditingGroup group: Group, newMembers: [User])
}

protocol AddGroupDelegate: class {
  func AddGroupCancel(controller: GroupSettingsController)
  func AddGroupSave(controller: GroupSettingsController, didFinishAddingGroup group: Group, newMembers: [User])
}

// MARK: GroupSettingsViewController
class GroupSettingsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, AddMemberDelegate {
    
  // MARK: - Outlets
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet weak var tripNameField: UITextField!
  @IBOutlet weak var startDateField: UITextField!
  @IBOutlet weak var endDateField: UITextField!
  @IBOutlet weak var memberTable: UITableView!
  
  // MARK: - Properties
  var group: Group?
  weak var editDelegate: EditGroupDelegate?
  weak var addDelegate: AddGroupDelegate?
  var segue: String? // either comes from "addGroup" in GroupListingController or "editGroup" in GroupHomeController
  
  var picture: UIImage?
  let imagePicker = UIImagePickerController()
  
  let dateFormatter = DateFormatter()
  
  private var startDatePicker: UIDatePicker?
  private var endDatePicker: UIDatePicker?
  
  private var startDate: Date?
  private var endDate: Date?
  
  let viewModelMember = GroupUsersViewModel()
  var newMembers = [User]()
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if segue == "addGroup" {
      self.navigationItem.title = "New Group"
    } else if segue == "editGroup" {
      self.navigationItem.title = "Edit Group"
    }
    
    dateFormatter.dateFormat = "MM/dd/yy"
    configureDatePickers()
    configureControls()
    
    let cellNib1 = UINib(nibName: "MemberTableCell", bundle: nil)
    memberTable.register(cellNib1, forCellReuseIdentifier: "member")
    memberTable.tableFooterView = UIView()
    
    if segue == "editGroup" {
      if let group = group {
        tripNameField.text = group.tripName
        startDateField.text = dateFormatter.string(from: group.startDate)
        endDateField.text = dateFormatter.string(from: group.endDate)
      }
      
      viewModelMember.refresh ({ [unowned self] in
        DispatchQueue.main.async {
          self.memberTable.reloadData()
        }
        }, url: "https://oneworldexchange.herokuapp.com/travel_group/1/members")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
  }
  
  // MARK: - Configurations
  func configureDatePickers() {
      // Configure datepickers
      endDatePicker = UIDatePicker()
      endDatePicker?.datePickerMode = .date
      endDatePicker?.addTarget(self, action: #selector(GroupSettingsController.endDateChanged(datePicker:)), for: .valueChanged)
      endDateField?.inputView = endDatePicker

      startDatePicker = UIDatePicker()
      startDatePicker?.datePickerMode = .date
      startDatePicker?.addTarget(self, action: #selector(GroupSettingsController.startDateChanged(datePicker:)), for: .valueChanged)
      startDateField?.inputView = startDatePicker
  }
  
  func configureControls() {
      // request image permission
      PHPhotoLibrary.requestAuthorization({_ in return})

      // configure image picker
      imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)

      // configure screen tap
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupSettingsController.viewTapped(gestureRecognizer:)) )
      view.addGestureRecognizer(tapGesture)
  }
  
  // MARK: - Handlers
  @objc func endDateChanged(datePicker: UIDatePicker) {
      endDateField.text = dateFormatter.string(from: datePicker.date)
      endDate = (endDatePicker?.date)!
  }

  @objc func startDateChanged(datePicker: UIDatePicker) {
      startDateField.text = dateFormatter.string(from: datePicker.date)
      startDate = (startDatePicker?.date)!
  }

  @objc func viewTapped(gestureRecognizer: UIGestureRecognizer) {
      view.endEditing(true)
      endDate = (endDatePicker?.date)!
      startDate = (startDatePicker?.date)!
  }
  
  // MARK: - Actions
  @IBAction func loadImageButtonTapped(sender: UIButton) {
      imagePicker.allowsEditing = false
      imagePicker.sourceType = .photoLibrary
    
      present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
          picture = pickedImage
          tripImage.image = picture
      }
      dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancel() {
    if segue == "editGroup" {
      editDelegate?.EditGroupCancel(controller: self)
    } else if segue == "addGroup" {
      addDelegate?.AddGroupCancel(controller: self)
    }
  }
  
  @IBAction func save() {
    if segue == "addGroup" {
      var newGroup = Group(id: 4, tripName: tripNameField.text!, startDate: dateFormatter.date(from: startDateField.text!)!, endDate: dateFormatter.date(from: endDateField.text!)!, members: [])
      //var group: Group?
      addDelegate?.AddGroupSave(controller: self, didFinishAddingGroup: newGroup, newMembers: newMembers)
    } else {
      group!.tripName = tripNameField.text!
      group!.startDate = dateFormatter.date(from: startDateField.text!)!
      group!.endDate = dateFormatter.date(from: endDateField.text!)!
      group!.image = picture
      //group!.members = viewModelMember.users
      editDelegate?.EditGroupSave(controller: self, didFinishEditingGroup: group!, newMembers: newMembers)
    }
    //self.saveGroup(group: group!)
//    if segue == "editGroup" {
//
//    } else if segue == "addGroup" {
//
//    }
  }
  
  func saveGroup(group: Group) {
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    // Specifically select the Group entity to save this object to
    let groupEntity = NSEntityDescription.entity(forEntityName: "Groups", in: context)
    let newGroup = NSManagedObject(entity: groupEntity!, insertInto: context)
    // Set values one at a time and save
    newGroup.setValue(group.tripName, forKey: "trip_name")
    newGroup.setValue(group.startDate, forKey: "start_date")
    newGroup.setValue(group.endDate, forKey: "end_date")
    // Safely unwrap the picture
    if let pic = group.image {
      newGroup.setValue(UIImagePNGRepresentation(pic), forKey: "picture")
    }
    do {
      try context.save()
      print("Success saving")
    } catch {
      print("Failed saving")
    }
    // Save new group members to Core Data
    for member in newMembers {
      let userGroupEntity = NSEntityDescription.entity(forEntityName: "User_Group", in: context)
      let newUserGroup = NSManagedObject(entity: userGroupEntity!, insertInto: context)
      newUserGroup.setValue(member.id, forKey: "user_id")
      newUserGroup.setValue(group.id, forKey: "travel_group_id")
    }
  }
  
  func addMembersToGroup(selectedMembers: [User]) {
    for member in selectedMembers {
      let newRowIndex = viewModelMember.users.count
      viewModelMember.users.append(member)
      newMembers.append(member)
      viewModelMember.addMemberToGroup(member: member)
      
      let indexPath = NSIndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      memberTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    }
    
    // remove member from all users
//    filteredUsers.remove(at: indexPath)
//    viewModelUser.users.remove(at: indexPath)
//    self.userTable.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModelMember.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user: User
    let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MemberTableCell
    user = viewModelMember.users[indexPath.row]
    cell.name.text = user.name
    return cell
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "searchUser" {
      let popoverController = segue.destination as! PopoverMemberSearchController
      popoverController.viewModelMember = self.viewModelMember
      popoverController.delegate = self as AddMemberDelegate
    }
  }
  
}

