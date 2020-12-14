//
//  TwoViewSecondView.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 12/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

protocol TwoViewSecondViewDelegate: class {
    func donePressed()
}

class TwoViewSecondView: UIView {
    struct DisplayModel {
        var title: String
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: HalfVCDelegate?
    weak var twoViewSecondViewDelegate: TwoViewSecondViewDelegate?
    
    var displayModel: DisplayModel?
    
    private func initialUISettings() {
        self.layer.cornerRadius = 15.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        doneButton.layer.cornerRadius = 7.0

        titleLabel.text = displayModel?.title
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        twoViewSecondViewDelegate?.donePressed()
    }
}

extension TwoViewSecondView: HalfVCView {

    public func assignValues(_ data: Any?, delegate: HalfVCDelegate) {
        self.delegate = delegate
        if let displayModel = data as? DisplayModel {
            self.displayModel = displayModel
        }
        self.initialUISettings()
    }

    public func giveSizeWith() -> CGSize {
        self.layoutIfNeeded()
        if self.intrinsicContentSize.width < 0 || self.intrinsicContentSize.height < 0 {
            return self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        } else {
            return self.intrinsicContentSize
        }
    }

    public func assignPresentingControllerDelegates(delegate: Any?) {
        if let twoViewSecondViewDelegate = delegate as? TwoViewSecondViewDelegate {
            self.twoViewSecondViewDelegate = twoViewSecondViewDelegate
        }
    }
}
