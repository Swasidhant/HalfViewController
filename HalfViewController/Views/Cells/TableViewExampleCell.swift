//
//  TableViewExampleCell.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 12/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

class TableViewExampleCell: UITableViewCell {

    @IBOutlet weak var rowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
