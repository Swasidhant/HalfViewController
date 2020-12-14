//
//  InfoView.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 11/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

protocol InfoViewDelegate: class {
    func understandBtnPressed()
}

class InfoView: UIView {
    struct DisplayModel {
        var title: String
        var subtitle: String
        var desc: String
        var imgName: String
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var sampleImageView: UIImageView!
    @IBOutlet weak var understandButton: UIButton!

    weak var delegate: HalfVCDelegate?
    weak var infoViewDelegate: InfoViewDelegate?
    
    var displayModel: DisplayModel?
    
    private func initialUISettings() {
        self.layer.cornerRadius = 15.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        understandButton.layer.cornerRadius = 7.0
        
        titleLabel.text = displayModel?.title
        subtitleLabel.text = displayModel?.subtitle
        descLabel.text = displayModel?.desc
        if let img = displayModel?.imgName {
            sampleImageView.image = UIImage(named: img)
        }
    }
    
    
    @IBAction func crossPressed(_ sender: UIButton) {
        delegate?.dismissController(completion: nil)
    }
    
    @IBAction func understandBtnPressed(_ sender: UIButton) {
        infoViewDelegate?.understandBtnPressed()
    }
}

extension InfoView: HalfVCView {

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
        if let infoViewDelegate = delegate as? InfoViewDelegate {
            self.infoViewDelegate = infoViewDelegate
        }
    }
}
