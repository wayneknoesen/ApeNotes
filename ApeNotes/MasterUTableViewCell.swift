//
//  MasterUTableViewCell.swift
//  ApeNotes
//
//  Created by Wayne Knoesen on 14/02/15.
//  Copyright (c) 2015 LeetApps. All rights reserved.
//

import UIKit

class MasterUTableViewCell: UITableViewCell {

    @IBOutlet weak var masterTitleLable: UILabel!
    @IBOutlet weak var masterTextLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
