//
//  GroupSettingsViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import Photos
import UIKit

// MARK: Protocol Methods

protocol AddGroupControllerDelegate: class {
    func GroupSettingsViewControllerDidCancel(controller: GroupSettingsViewController)
    
    func addGroupController(controller: GroupSettingsViewController, didFinishCreatingGroup group: Group)
}

// MARK: GroupSettingsViewController
class GroupSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet weak var tripNameField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var usersSelect: UITextField!
    @IBOutlet weak var userTable: UITableView!
    
    // MARK: - Properties
    weak var delegate: AddGroupControllerDelegate?
    
    let imagePicker = UIImagePickerController()
    private var endDatePicker: UIDatePicker?
    private var startDatePicker: UIDatePicker?
    private var userPicker: UIPickerView?
    
    var groups = [Group]()
    var dataManager = DataManager()
    private var startDate: Date?
    private var endDate: Date?
    private var users = [User]()
    
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.loadGroups()
        groups = dataManager.groups
        
        // Configure datepickers
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(GroupSettingsViewController.endDateChanged(datePicker:)), for: .valueChanged)
        endDateField.inputView = endDatePicker
        endDate = (endDatePicker?.date)!
        
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(GroupSettingsViewController.startDateChanged(datePicker:)), for: .valueChanged)
        startDateField.inputView = startDatePicker
        startDate = (startDatePicker?.date)!
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupSettingsViewController.viewTapped(gestureRecognizer:)) )
        view.addGestureRecognizer(tapGesture)
        
        // Configure User Selector
        userPicker = UIPickerView()
        
    }
    
// MARK: - Handlers
    @objc func endDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        endDateField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        startDateField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
//    @IBAction func cancel() {
//        delegate?.addGroupControllerDidCancel(controller: self)
//    }
    
    @IBAction func done() {
        let group = Group()
        group.title = tripNameField.text!
        group.image = tripImage.image!
//        group.users = users
        group.startDate = startDate!
        group.endDate = endDate!
        
        if group.title.count > 0 {
            delegate?.addGroupController(controller: self, didFinishCreatingGroup: group)
        }
    }
    
}
