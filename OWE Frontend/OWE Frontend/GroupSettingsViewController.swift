//
//  GroupSettingsViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

class GroupSettingsViewController: UIViewController {
    
// MARK: - View Variables and Outlets
    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var users: UITextField!
    
    private var endDatePicker: UIDatePicker?
    private var startDatePicker: UIDatePicker?
    private var userPicker: UIPickerView?
    
// MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure datepickers
        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(GroupSettingsViewController.endDateChanged(datePicker:)), for: .valueChanged)
        endDate.inputView = endDatePicker
        
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(GroupSettingsViewController.startDateChanged(datePicker:)), for: .valueChanged)
        startDate.inputView = startDatePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GroupSettingsViewController.viewTapped(gestureRecognizer:)) )
        view.addGestureRecognizer(tapGesture)
        
        // Configure User Selector
        userPicker = UIPickerView()
        
    }
    
// MARK: - Handlers
    @objc func endDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        endDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        startDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
    }
}
