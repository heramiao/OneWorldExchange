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
  @IBOutlet weak var amtField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

//  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//    self.selectionStyle = .none
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//
  override func setSelected(_ selected: Bool, animated: Bool) {
    //super.setSelected(selected, animated: animated)
    //self.accessoryType = selected ? .checkmark : .none
  }

}
