//  GroupSettingsViewController.swift
//  OWE Frontend

import Foundation
import CoreData
import Photos
import UIKit

// MARK: Protocol Methods

protocol GroupSettingsControllerDelegate: class {
    func groupSettingsControllerDidCancel(controller: GroupSettingsController)
    func groupSettingsController(controller: GroupSettingsController, didFinishCreatingGroup group: Group)
}

// MARK: - UISearch extension
extension GroupSettingsController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

// MARK: GroupSettingsViewController
class GroupSettingsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
  // MARK: - Outlets
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet weak var tripNameField: UITextField!
  @IBOutlet weak var startDateField: UITextField!
  @IBOutlet weak var endDateField: UITextField!
  @IBOutlet weak var memberTable: UITableView!
  @IBOutlet weak var userTable: UITableView!
  
  // MARK: - Properties
  weak var delegate: GroupSettingsControllerDelegate?
  
  var picture: UIImage?
  let imagePicker = UIImagePickerController()
  let dateFormatter = DateFormatter()
  
  private var endDatePicker: UIDatePicker?
  private var startDatePicker: UIDatePicker?
  private var userPicker: UIPickerView?
  
  private var startDate: Date?
  private var endDate: Date?
  //    private var users = [User]()
  
  let viewModel = GroupSettingsViewModel()
  let viewModel1 = GroupSettingsViewModel()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredUsers = [User]()
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateFormat = "MM/dd/yy"
    self.configureView()
    
    let cellNib = UINib(nibName: "AddMemberTableCell", bundle: nil)
    userTable.register(cellNib, forCellReuseIdentifier: "addmember")
    
    let cellNib1 = UINib(nibName: "MemberTableCell", bundle: nil)
    memberTable.register(cellNib1, forCellReuseIdentifier: "member")
    
    setupSearchBar()
    
    viewModel.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.userTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/users")
    
    viewModel1.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.memberTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/travel_group/1/members")
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      tripNameField.becomeFirstResponder()
      //    doneBarButton.isEnabled = false
  }
  
  // MARK: - Configurations
  var detailItem: Group? {
      didSet {
          // Update the view.
          self.configureView()
      }
  }
  
  func configureView() {
      let dateFormatter = DateFormatter()
      configureDatePickers()
      configureControls()
    
      // Update the user interface for the detail item.
      if let detail: Group = self.detailItem {
          if let picture = self.tripImage {
              picture.image = detail.image
          }
          if let tripNameField = self.tripNameField {
              tripNameField.text = detail.title
          }
          if let startDateField = self.startDateField {
              self.startDate = detail.startDate!
              startDateField.text = dateFormatter.string(from: startDate!)
          }
          if let endDateField = self.endDateField {
              self.endDate = detail.endDate!
              endDateField.text = dateFormatter.string(from: endDate!)
          }
          self.navigationItem.title = detail.title
      }
  }
  
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
      delegate?.groupSettingsControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
      if let group = self.detailItem {
          updateGroup(group:group)
          //            delegate?.groupSettingsController(controller: self, didFinishUpdatingGroup: group)
      }
      else {
          let group = makeGroup()
          saveGroup(group: group)
          if group.title.count > 0 {
              delegate?.groupSettingsController(controller: self, didFinishCreatingGroup: group)
          }
      }
  }
  
  func makeGroup() -> Group {
      var group = Group()
      group.title = tripNameField.text!
      group.image = tripImage.image!
      //        group.users = users
      group.startDate = startDate!
      group.endDate = endDate!
      return group
  }
  
  func saveGroup(group: Group) {
      // Connect to the context for the container stack
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      // Specifically select the Group entity to save this object to
      let entity = NSEntityDescription.entity(forEntityName: "Groups", in: context)
      let newGroup = NSManagedObject(entity: entity!, insertInto: context)
      // Set values one at a time and save
      newGroup.setValue(group.title, forKey: "title")
      newGroup.setValue(group.startDate, forKey: "start_date")
      newGroup.setValue(group.endDate, forKey: "end_date")
      // Safely unwrap the picture
      if let pic = group.image {
          newGroup.setValue(UIImagePNGRepresentation(pic), forKey: "picture")
      }
      do {
          try context.save()
      } catch {
          print("Failed saving")
      }
  }
  
  func updateGroup(group: Group) {
//        // Connect to the context for the container stack
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        // Specifically select the Group entity to save this object to
//        let moc = ...
//        let title = self.tripNameField.text
//        let entitiesRequest = NSFetchRequest(entityName: "Groups").predicate = NSPredicate(format: "title == %@", title)
//        do {
//            let trip = try moc.executeFetchRequest(employeesFetch) as! [EmployeeMO]
//        } catch {
//            fatalError("Failed to fetch trip: \(error)")
//        }
    
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
        return viewModel.numberOfRows()
      } else {
        return 0
      }
    } else {
      return viewModel1.numberOfRows()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user: User
    if tableView == self.userTable {
      let cell = tableView.dequeueReusableCell(withIdentifier: "addmember", for: indexPath) as! AddMemberTableCell
      if isFiltering() {
        user = filteredUsers[indexPath.row]
      } else {
        user = viewModel.users[indexPath.row]
      }
      cell.name.text = user.name
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MemberTableCell
      user = viewModel1.users[indexPath.row]
      cell.name.text = user.name
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // if member selected, remove from search table and add to members table
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
    filteredUsers = viewModel.users.filter { user in
      return user.name.lowercased().contains(searchText.lowercased())
    }
    userTable.reloadData()
  }
  
  
  
}

