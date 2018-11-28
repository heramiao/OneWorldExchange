//  GroupSettingsViewController.swift
//  OWE Frontend

import Foundation
import CoreData
import Photos
import UIKit

// MARK: Protocol Methods
protocol GroupSettingsControllerDelegate: class {
    func groupSettingsCancel(controller: GroupSettingsController)
    func groupSettingsSave(controller: GroupSettingsController, didFinishChangingGroup group: Group)
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
  weak var delegate: GroupSettingsControllerDelegate?
  
  var picture: UIImage?
  let imagePicker = UIImagePickerController()
  
  let dateFormatter = DateFormatter()
  
  private var startDatePicker: UIDatePicker?
  private var endDatePicker: UIDatePicker?
  private var userPicker: UIPickerView?
  
  private var startDate: Date?
  private var endDate: Date?
  
  let viewModelUser = GroupUsersViewModel()
  let viewModelMember = GroupUsersViewModel()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredUsers = [User]()
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateFormat = "MM/dd/yy"
    configureDatePickers()
    configureControls()
    
    let cellNib = UINib(nibName: "AddMemberTableCell", bundle: nil)
    userTable.register(cellNib, forCellReuseIdentifier: "addmember")
    
    let cellNib1 = UINib(nibName: "MemberTableCell", bundle: nil)
    memberTable.register(cellNib1, forCellReuseIdentifier: "member")
    
    setupSearchBar()
    
    if let group = group {
      tripNameField.text = group.tripName
      startDateField.text = dateFormatter.string(from: group.startDate)
      endDateField.text = dateFormatter.string(from: group.endDate)
    }
    
    viewModelUser.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.userTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/users")
    
    viewModelMember.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.memberTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_group/1/members")
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

      // Configure User Selector
      userPicker = UIPickerView()
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
      delegate?.groupSettingsCancel(controller: self)
  }
  
  @IBAction func save() {
//      if let group = self.detailItem {
//          updateGroup(group:group)
//          //            delegate?.groupSettingsController(controller: self, didFinishUpdatingGroup: group)
//      }
//      else {
//          let group = makeGroup()
//          saveGroup(group: group)
//          if group.title.count > 0 {
//              delegate?.groupSettingsSave(controller: self, didFinishChangingGroup: group)
//          }
//      }
    group!.tripName = tripNameField.text!
    group!.startDate = dateFormatter.date(from: startDateField.text!)!
    group!.endDate = dateFormatter.date(from: endDateField.text!)!
    // group!.users =
    delegate?.groupSettingsSave(controller: self, didFinishChangingGroup: group!)
  }
  
  func addMember(class: AddMemberTableCell, didFinishAdding member: User) {
    let newRowIndex = viewModelMember.users.count
    viewModelMember.users.append(member)
    viewModelMember.addMemberToGroup(member: member)
    
    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    memberTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
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
    filteredUsers = viewModelUser.users.filter { user in
      return user.name.lowercased().contains(searchText.lowercased())
    }
    userTable.reloadData()
  }
  
}

