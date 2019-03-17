//
//  MemberTableCell.swift
//  OWE Frontend
//
//  Created by Hera Miao on 11/17/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit


protocol SelectMemberDelegate: class {
  func selectMember(cell: AddMemberTableCell, didFinishAdding member: User, indexPath: Int)
  func removeMember(cell: AddMemberTableCell, didFinishAdding member: User, indexPath: Int)
}

class AddMemberTableCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  var member: User?
  var indexPath: Int?
  var delegate: SelectMemberDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @IBAction func addMemberTapped(_ sender: UIButton) {
    if sender.titleLabel?.text == "Add" {
      delegate?.selectMember(cell: self, didFinishAdding: member!, indexPath: indexPath!)
      sender.setTitle("Remove", for: .normal)
    } else {
      delegate?.removeMember(cell: self, didFinishAdding: member!, indexPath: indexPath!)
      sender.setTitle("Add", for: .normal)
    }
  }
  
}
