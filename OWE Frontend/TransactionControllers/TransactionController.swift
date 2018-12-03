////
////  TransactionViewController.swift
////  OWE Frontend
////
////  Created by Hera Miao on 11/6/18.
////  Copyright © 2018 Juliann Fields. All rights reserved.
////
//
import UIKit

protocol NewTransactionDelegate: class {
  func NewTransactionCancel(controller: TransactionController)
  
  func NewTransactionSave(controller: TransactionController, didFinishCreatingTransaction transaction: Transaction)
}

class TransactionController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

  var group: Group?
  var transaction: Transaction?
  var delegate: NewTransactionDelegate?
  
  // MARK: - Outlets
  @IBOutlet weak var currencyTypeField: UITextField!
  @IBOutlet weak var currencyAmountField: UITextField!
  @IBOutlet weak var paidByField: UITextField!
  @IBOutlet weak var descriptionField: UITextField!
  @IBOutlet weak var countryField: UITextField!
  @IBOutlet weak var expenseTypeField: UITextField!
  @IBOutlet weak var splitTypeField: UISegmentedControl!
  @IBOutlet weak var whoOwesTable: UITableView!
  @IBOutlet weak var currSymbol: UILabel!
  @IBOutlet weak var remainingAmt: UILabel!
  
  
  var currType = ["AUD", "CAD", "CHF", "CNY", "EUR", "GBP", "JPY", "MXN", "SEK", "USD"]
  var expType = ["Entertainment", "Food", "Lodging", "Shopping", "Transportation", "Other"]
  var members = [String]()
  var pickerCurrType = UIPickerView()
  var pickerExpType = UIPickerView()
  var pickerMembers = UIPickerView()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    for member in group!.members {
      members.append(member.name)
    }

    pickerCurrType.delegate = self
    pickerCurrType.dataSource = self
    pickerExpType.delegate = self
    pickerExpType.dataSource = self
    pickerMembers.delegate = self
    pickerMembers.dataSource = self
    currencyTypeField.inputView = pickerCurrType
    expenseTypeField.inputView = pickerExpType
    paidByField.inputView = pickerMembers
    
    let cellNib = UINib(nibName: "WhoOwesTableCell", bundle: nil)
    whoOwesTable.register(cellNib, forCellReuseIdentifier: "whoowes")
    
  }
  
  @IBAction func cancel() {
    delegate?.NewTransactionCancel(controller: self)
  }
  
  @IBAction func save() {
    
    //delegate?.NewTransactionSave(controller: self, didFinishCreatingTransaction: transaction!)
  }

  // MARK: - UIPickerView
  
  // Number of columns of data
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // The number of rows of data
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == pickerCurrType {
      return currType.count }
    if pickerView == pickerExpType {
      return expType.count
    } else {
      return members.count
    }
  }
  
  // The data to return for the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == pickerCurrType {
      return currType[row] }
    if pickerView == pickerExpType {
      return expType[row]
    } else {
      return members[row]
    }
  }
  
  // Capture the picker view selection
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == pickerCurrType {
      currencyTypeField.text = currType[row] }
    if pickerView == pickerExpType {
      expenseTypeField.text = expType[row]
    } else {
      paidByField.text = members[row]
    }
    self.view.endEditing(true)
  }
  
  // MARK: - Search Who Owes Table Views
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return members.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "whoowes", for: indexPath) as! WhoOwesTableCell
    let member = members[indexPath.row]
    cell.nameLabel!.text = member
    return cell
  }

}
