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

// MARK: - UISearch extension
extension GroupSettingsController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

// MARK: GroupSettingsViewController
class GroupSettingsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, AddMemberDelegate {
    
  // MARK: - Outlets
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet weak var tripNameField: UITextField!
  @IBOutlet weak var startDateField: UITextField!
  @IBOutlet weak var endDateField: UITextField!
  @IBOutlet weak var memberTable: UITableView!
  @IBOutlet weak var userTable: UITableView!
  
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
  
  let viewModelUser = GroupUsersViewModel()
  let viewModelMember = GroupUsersViewModel()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredUsers = [User]()
  var newMembers = [User]()
  var notInGroup = [User]()
  
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
    
    let cellNib = UINib(nibName: "AddMemberTableCell", bundle: nil)
    userTable.register(cellNib, forCellReuseIdentifier: "addmember")
    
    let cellNib1 = UINib(nibName: "MemberTableCell", bundle: nil)
    memberTable.register(cellNib1, forCellReuseIdentifier: "member")
    
    memberTable.tableFooterView = UIView()
    userTable.tableFooterView = UIView()
    
    viewModelUser.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.userTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/users")
    
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
  
  @IBAction func addNewMembers() {
    setupSearchBar()
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
  
  func addMember(class: AddMemberTableCell, didFinishAdding member: User, indexPath: Int) {
    let newRowIndex = viewModelMember.users.count
    viewModelMember.users.append(member)
    newMembers.append(member)
    viewModelMember.addMemberToGroup(member: member)

    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    memberTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    
    // remove member from all users
//    filteredUsers.remove(at: indexPath)
//    viewModelUser.users.remove(at: indexPath)
//    self.userTable.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
  }
  
   // get all the users in the system that aren't currenly in the group
  func newUsers(allUsers: [User], groupUsers: [User]) -> [User] {
    var newUsers = [User]()
    for user in allUsers {
      var count = 0
      for member in groupUsers {
        if user === member {
          print("true")
          break
        } else {
          count += 1
        }
      }
      if count == groupUsers.count {
        newUsers.append(user)
        //print(user.name)
        continue
      } else {
        continue
      }
    }
    return newUsers
    
//    var newUsers = [User]()
//    for user in allUsers {
//      if !groupUsers.contains(user) {
//        newUsers.append(user)
//        print(user)
//      }
//    }
//    return newUsers
  }
  
  // MARK: - Search User Table Views
  func beginSearch() -> Bool {
    return searchController.isActive
  }
  
  func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.userTable {
      if isFiltering() {
        return filteredUsers.count
      } else if beginSearch() {
        return viewModelUser.numberOfRows()
      } else {
        return 0
      }
    } else {
      return viewModelMember.numberOfRows()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user: User
    if tableView == self.userTable {
      let cell = tableView.dequeueReusableCell(withIdentifier: "addmember", for: indexPath) as! AddMemberTableCell
      cell.delegate = self as AddMemberDelegate
      cell.indexPath = indexPath.row
      if isFiltering() {
        user = filteredUsers[indexPath.row]
      } else {
        user = viewModelUser.users[indexPath.row]
      }
      cell.member = user
      cell.nameLabel.text = user.name
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MemberTableCell
      user = viewModelMember.users[indexPath.row]
//      if let index = notInGroup.index(of: user)
//      notInGroup.remove(
      cell.name.text = user.name
      return cell
    }
  }
  
  //MARK: - Search Methods
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    searchController.searchBar.placeholder = "Add New Members"
    //navigationItem.searchController = searchController
    //userTable.tableHeaderView = searchController.searchBar
    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
    } else {
      userTable.tableHeaderView = searchController.searchBar
    }
    searchController.searchBar.barTintColor = UIColor(red:0.98, green:0.48, blue:0.24, alpha:1.0)
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    let notInGroup = newUsers(allUsers: viewModelUser.users, groupUsers: viewModelMember.users)
    //print(notInGroup.count)
    
    filteredUsers = viewModelUser.users.filter { user in
      return user.name.lowercased().contains(searchText.lowercased())
    }
    userTable.reloadData()
  }
  
}

