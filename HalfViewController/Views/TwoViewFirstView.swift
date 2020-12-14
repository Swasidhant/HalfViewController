//
//  TwoViewFirst.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 12/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

class TwoViewFirstView: UIView {
    struct DisplayModel {
        var title: String
        var subtitle: String
        var desc: String
        var newXIBName: String
        var nextScreenModel: TwoViewSecondView.DisplayModel
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: HalfVCDelegate?
    
    var displayModel: DisplayModel?
    
    private func initialUISettings() {
        self.layer.cornerRadius = 15.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        nextButton.layer.cornerRadius = 7.0

        titleLabel.text = displayModel?.title
        subtitleLabel.text = displayModel?.subtitle
        descLabel.text = displayModel?.desc
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        if let displayModel = displayModel {
            delegate?.loadNewXib(xibName: displayModel.newXIBName, bundle: Bundle.main, data: displayModel.nextScreenModel)
        }
    }
}

extension TwoViewFirstView: HalfVCView {

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
}
