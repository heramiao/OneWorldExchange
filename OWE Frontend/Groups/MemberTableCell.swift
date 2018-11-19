//
//  MemberTableCell.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/17/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class MemberTableCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var addMember: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
