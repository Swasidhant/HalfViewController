//
//  OptionsCollectionCell.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 08/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

class OptionsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func assignTitle(_ title: String) {
        titleLabel.text = title
    }
}
