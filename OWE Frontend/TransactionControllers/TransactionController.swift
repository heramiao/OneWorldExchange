////
////  TransactionViewController.swift
////  OWE Frontend
////
////  Created by Hera Miao on 11/6/18.
////  Copyright © 2018 Juliann Fields. All rights reserved.
////
//
import UIKit

class TransactionController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

  var group: Group?
  
  // MARK: - Outlets
  @IBOutlet weak var currencyTypeField: UITextField!
  @IBOutlet weak var currencyAmountField: UITextField!
  @IBOutlet weak var paidByField: UITextField!
  @IBOutlet weak var descriptionField: UITextField!
  @IBOutlet weak var countryField: UITextField!
  @IBOutlet weak var expenseTypeField: UITextField!
  @IBOutlet weak var splitTypeField: UISwitch!
  
  
  var currType = ["AUD", "CAD", "CHF", "CNY", "EUR", "GBP", "JPY", "MXN", "SEK", "USD"]
  var members = [String]()
  var pickerCurrType = UIPickerView()
  var pickerMembers = UIPickerView()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    for member in group!.members {
      members.append(member.name)
    }

    pickerCurrType.delegate = self
    pickerCurrType.dataSource = self
    pickerMembers.delegate = self
    pickerMembers.dataSource = self
    currencyTypeField.inputView = pickerCurrType
    paidByField.inputView = pickerMembers
  }
  
  @IBAction func cancel() {
  
  }
  
  @IBAction func save() {
  
  }

  // MARK: - UIPickerView
  
  // Number of columns of data
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == pickerCurrType {
      return currType.count
    } else {
      return members.count
    }
  }
  
  // The data to return for the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == pickerCurrType {
      return currType[row]
    } else {
      return members[row]
    }
  }
  
  // Capture the picker view selection
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == pickerCurrType {
      currencyTypeField.text = currType[row]
    } else {
      paidByField.text = members[row]
    }
    self.view.endEditing(true)
  }

}
