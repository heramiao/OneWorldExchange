//
//  GroupTableViewCell.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/5/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var tripStartDate: UILabel!
    @IBOutlet weak var tripEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
