//
//  MemberTableCell.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/17/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

protocol AddMemberDelegate: class {
  func addMember(class: AddMemberTableCell, didFinishAdding member: User, indexPath: Int)
}

class AddMemberTableCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  var member: User?
  var indexPath: Int?
  var delegate: AddMemberDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @IBAction func addMemberTapped(_ sender: UIButton) {
    delegate?.addMember(class: self, didFinishAdding: member!, indexPath: indexPath!)
  }
  
}
