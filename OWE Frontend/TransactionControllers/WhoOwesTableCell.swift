//
//  ViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 12/2/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class WhoOwesTableCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var currLabel: UILabel!
  @IBOutlet weak var amtLabel: UILabel!
  @IBOutlet weak var changeSwitch: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

}
