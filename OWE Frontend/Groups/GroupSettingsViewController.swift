//
//  GroupSettingsViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import CoreData
import Photos
import UIKit

// MARK: Protocol Methods

protocol GroupSettingsControllerDelegate: class {
    func groupSettingsControllerDidCancel(controller: GroupSettingsController)
    
    func groupSettingsController(controller: GroupSettingsController, didFinishCreatingGroup group: Group)
}

// MARK: GroupSettingsViewController
class GroupSettingsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
  
  let viewModel = GroupSettingsViewModel()
    
  // MARK: - Outlets
  @IBOutlet weak var tripImage: UIImageView!
  @IBOutlet weak var tripNameField: UITextField!
  @IBOutlet weak var startDateField: UITextField!
  @IBOutlet weak var endDateField: UITextField!
  @IBOutlet weak var memberSearch: UISearchBar!
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
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateFormat = "MM/dd/yy"
    self.configureView()
    
    let cellNib = UINib(nibName: "MemberTableCell", bundle: nil)
    userTable.register(cellNib, forCellReuseIdentifier: "addmember")
    
    viewModel.refresh { [unowned self] in
      DispatchQueue.main.async {
        self.userTable.reloadData()
      }
    }
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

  // MARK: - Table Views
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "addmember", for: indexPath) as! MemberTableCell
    cell.name.text = viewModel.nameForRowAtIndexPath(indexPath)
    // cell.button = viewModel.addMember
    return cell
  }
    
}
