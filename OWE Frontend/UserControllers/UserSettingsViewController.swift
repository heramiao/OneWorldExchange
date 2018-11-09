//
//  UserSettingsViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/30/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit
import CoreData

// MARK: Protocol Methods

protocol UserSettingsDelegate: class {
  func UserSettingsCancel(controller: UserSettingsViewController)
  
  func UserSettingsSave(controller: UserSettingsViewController, didFinishAddingSettings user: User)
}

class UserSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  var profile: User?
  var delegate: UserSettingsDelegate?
  
  // MARK: - Outlets
  
  @IBOutlet weak var fnameField: UITextField!
  @IBOutlet weak var lnameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var baseCurrField: UIPickerView!
  @IBOutlet weak var oldPassField: UITextField!
  @IBOutlet weak var newPassField: UITextField!
  @IBOutlet weak var newPassConField: UITextField!
  
  // MARK: - General
  
  var pickerData = ["USD", "EUR", "GBP", "CHF", "AUD", "JPY", "TWD", "CNH"]
  var picker = UIPickerView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    picker.delegate = self
    picker.dataSource = self
    
    if let user = profile {
      fnameField.text = user.firstName
      lnameField.text = user.lastName
      emailField.text = user.email
      phoneField.text = user.phone
      // baseCurrField.text = user.baseCurrency
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - UIPickerView
  
  // Number of columns of data
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
  }
  
  // The data to return for the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
  }
  
  // Capture the picker view selection
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    baseCurrField.text = pickerData[row]
    self.view.endEditing(false)
  }
  
  // MARK: - Actions
  
  @IBAction func cancel() {
    delegate?.UserSettingsCancel(controller: self)
  }
  
  @IBAction func save() {
    profile!.firstName = fnameField.text!
    profile!.lastName = lnameField.text!
    profile!.email = emailField.text!
    profile!.phone = phoneField.text!
    // profile!.baseCurrency = baseCurrField.text!
    // user.password = new password or old password if newPassField not filled in
    // user.passwordConfirmation =
    self.saveUser(user: profile!) // saving to Core Data
    delegate?.UserSettingsSave(controller: self, didFinishAddingSettings: profile!)
  }
  
  // MARK: - Core Data
  
  func saveUser(user: User){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
    let newUser = NSManagedObject(entity: entity!, insertInto: context)
    newUser.setValue(user.firstName, forKey: "first_name")
    newUser.setValue(user.lastName, forKey: "last_name")
    newUser.setValue(user.email, forKey: "email")
    newUser.setValue(user.phone, forKey: "phone")
    // newUser.setValue(user.baseCurrency, forKey: "base_currency")
    // newUser.setValue(user.password, forKey: "password")
    // newUser.setValue(user.passwordConfirmation, forKey: "password_confirmation")
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
