//
//  SplitsTableCell.swift
//  OWE Frontend
//
//  Created by Hera Miao on 12/3/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

protocol PaySplitDelegate: class {
  func paySplit(cell: SplitsTableCell, payor: User, amountOwed: String, indexPath: Int)
}

class SplitsTableCell: UITableViewCell {

  @IBOutlet weak var payorName: UILabel!
  @IBOutlet weak var payeeName: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var descript: UILabel!
  @IBOutlet weak var orgCurrSymbol: UILabel!
  @IBOutlet weak var orgAmt: UILabel!
  @IBOutlet weak var baseCurrSymbol: UILabel!
  @IBOutlet weak var convertedAmt: UILabel!
  @IBOutlet weak var payBtn: UIButton!
  
  var payor: User?
  var amountOwed: String?
  var indexPath: Int?
  var delegate: PaySplitDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    //super.setSelected(selected, animated: animated)
    //self.accessoryType = selected ? .checkmark : .none
  }
  
  @IBAction func paySelected() {
    delegate?.paySplit(cell: self, payor: payor!, amountOwed: amountOwed!, indexPath: indexPath!)
  }
  
}
