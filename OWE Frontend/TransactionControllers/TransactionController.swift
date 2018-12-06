////
////  TransactionViewController.swift
////  OWE Frontend
////
////  Created by Hera Miao on 11/6/18.
////  Copyright © 2018 Juliann Fields. All rights reserved.
////
//
import UIKit
import Foundation

protocol NewTransactionDelegate: class {
  func NewTransactionCancel(controller: TransactionController)
  
  func NewTransactionSave(controller: TransactionController, didFinishCreatingSplit split: Split)
}

class TransactionController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

  var group: Group?
  var transaction: Transaction?
  var delegate: NewTransactionDelegate?
  let viewModel = TransactionViewModel()
  let dateFormatter = DateFormatter()
  var payor: User?
  var payee: User?
  
  // MARK: - Outlets
  @IBOutlet weak var currencyTypeField: UITextField!
  @IBOutlet weak var currencyAmountField: UITextField!
  @IBOutlet weak var paidByField: UITextField!
  @IBOutlet weak var descriptionField: UITextField!
  @IBOutlet weak var countryField: UITextField!
  @IBOutlet weak var expenseTypeField: UITextField!
  @IBOutlet weak var splitType: UISegmentedControl!
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
    
    dateFormatter.dateFormat = "MM/dd/yy"

    pickerCurrType.delegate = self
    pickerCurrType.dataSource = self
    pickerExpType.delegate = self
    pickerExpType.dataSource = self
    pickerMembers.delegate = self
    pickerMembers.dataSource = self
    currencyTypeField.inputView = pickerCurrType
    expenseTypeField.inputView = pickerExpType
    paidByField.inputView = pickerMembers
    
    //self.splitType.setSelectedSegmentIndex:UISegmentedControlNoSegment
    
    let cellNib = UINib(nibName: "WhoOwesTableCell", bundle: nil)
    whoOwesTable.register(cellNib, forCellReuseIdentifier: "whoowes")
    
    //self.whoOwesTable.allowsMultipleSelection = true
    //self.whoOwesTable.allowsMultipleSelectionDuringEditing = true
    
    currencyAmountField!.addTarget(self, action: #selector(amtPaidDidChange(_:)), for: .editingChanged)
  }
  
  @objc func amtPaidDidChange(_ textField: UITextField) {
    remainingAmt!.text = currencyAmountField!.text
  }
  
//  var totalAssigned = Float(0.00)
//  @objc func splitAmtDidChange(_ textField: UITextField) {
//    for i in 0...members.count-1 {
//      let indexPath = NSIndexPath(row: i, section: 0)
//      let cell = whoOwesTable.cellForRow(at: indexPath as IndexPath) as! WhoOwesTableCell
//      if cell.amtField!.text! != nil {
//        let numberFormatter = NumberFormatter()
//        let amt = numberFormatter.number(from: cell.amtField!.text!)
//        let amtFloatValue = amt!.floatValue
//        totalAssigned += amtFloatValue
//        let currAmtField = numberFormatter.number(from: currencyAmountField!.text!)
//        let currAmtFloatValue = currAmtField!.floatValue
//        self.remainingAmt!.text = String(format: "%0.2f", currAmtFloatValue - totalAssigned)
//      } else {
//        return
//      }
//    }
//  }
  
  @IBAction func splitTypeChanged(_ sender: Any) {
    if splitType.selectedSegmentIndex == 0 {
      for i in 0...members.count-1 {
        let indexPath = NSIndexPath(row: i, section: 0)
        let cell = whoOwesTable.cellForRow(at: indexPath as IndexPath) as! WhoOwesTableCell
        cell.amtField!.text = "0.00"
      }
    }
    if splitType.selectedSegmentIndex == 1 {
      for i in 0...members.count-1 {
        let indexPath = NSIndexPath(row: i, section: 0)
        let cell = whoOwesTable.cellForRow(at: indexPath as IndexPath) as! WhoOwesTableCell
        let numberFormatter = NumberFormatter() // use to format currencyAmountField to a float
        let amt = numberFormatter.number(from: currencyAmountField!.text!)
        let amtFloatValue = amt!.floatValue
        cell.amtField!.text = String(format: "%0.2f", (amtFloatValue / Float(members.count)))
      }
    }
  }
  
  @IBAction func cancel() {
    delegate?.NewTransactionCancel(controller: self)
  }
  
  @IBAction func save() {
    for i in 0...members.count-1 {
      let indexPath = NSIndexPath(row: i, section: 0)
      let cell = whoOwesTable.cellForRow(at: indexPath as IndexPath) as! WhoOwesTableCell
      if cell.amtField.text != "0.00" {
        let split = Split()
        split.payee = payee
        split.payor = group!.members[i]
        split.datePaid = dateFormatter.string(from: Date())
        split.descript = descriptionField.text!
        split.currencyAbrev = currencyTypeField.text!
        split.currencySymb = cell.currLabel.text!
        split.amountOwed = cell.amtField.text!
        delegate?.NewTransactionSave(controller: self, didFinishCreatingSplit: split)
      } else {
        continue
      }
      dismiss(animated: true, completion: nil)
    }
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
    } else if pickerView == pickerExpType {
      return expType.count
    } else {
      return members.count
    }
  }
  
  // The data to return for the row and component (column) that's being passed in
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == pickerCurrType {
      return currType[row]
    } else if pickerView == pickerExpType {
      return expType[row]
    } else {
      return members[row]
    }
  }
  
  // Capture the picker view selection
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == pickerCurrType {
      currencyTypeField.text = currType[row]
      currSymbol.text = viewModel.currToSymbol(currType: currType[row])
      for i in 0...members.count-1 {
        let indexPath = NSIndexPath(row: i, section: 0)
        let cell = whoOwesTable.cellForRow(at: indexPath as IndexPath) as! WhoOwesTableCell
        cell.currLabel!.text = viewModel.currToSymbol(currType: currType[row])
      }
    } else if pickerView == pickerExpType {
      expenseTypeField.text = expType[row]
    } else {
      payee = group!.members[row]
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
    //cell.amtField!.addTarget(self, action: #selector(splitAmtDidChange(_:)), for: .editingChanged)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let selectedMember = members[indexPath.row]
    print(selectedMember)
  }

}
