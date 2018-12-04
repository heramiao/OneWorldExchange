//
//  SplitsTableCell.swift
//  OWE Frontend
//
//  Created by Hera Miao on 12/3/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class SplitsTableCell: UITableViewCell {

  @IBOutlet weak var payorName: UILabel!
  @IBOutlet weak var payeeName: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var descript: UILabel!
  @IBOutlet weak var orgCurrSymbol: UILabel!
  @IBOutlet weak var orgAmt: UILabel!
  @IBOutlet weak var baseCurrSymbol: UILabel!
  @IBOutlet weak var convertedAmt: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    //super.setSelected(selected, animated: animated)
    //self.accessoryType = selected ? .checkmark : .none
  }
  
}
