//
//  AlertView.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 12/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

class AlertExampleView: UIView {
    struct DisplayModel {
        var title: String
        var desc: String
        var alertMsg: String
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    
    weak var delegate: HalfVCDelegate?
    
    var displayModel: DisplayModel?
    
    private func initialUISetting() {
        self.layer.cornerRadius = 15.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        alertButton.layer.cornerRadius = 7.0
        
        titleLabel.text = displayModel?.title
        descLabel.text = displayModel?.desc
    }
    
    @IBAction func showAlertPressed(_ sender: UIButton) {
        if let message = displayModel?.alertMsg {
            delegate?.showAlert(title: "Alert!!!", message: message)
        }
    }
}

extension AlertExampleView: HalfVCView {

    public func assignValues(_ data: Any?, delegate: HalfVCDelegate) {
        self.delegate = delegate
        if let displayModel = data as? DisplayModel {
            self.displayModel = displayModel
        }
        self.initialUISetting()
    }

    public func giveSizeWith() -> CGSize {
        self.layoutIfNeeded()
        if self.intrinsicContentSize.width < 0 || self.intrinsicContentSize.height < 0 {
            return self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        } else {
            return self.intrinsicContentSize
        }
    }
}
