//
//  MesagesTableViewCell.swift
//  TajKat
//
//  Created by Admin on 7/10/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import UIKit

class MesagesTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
