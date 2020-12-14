//
//  KeyboardView.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 12/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate: class {
    func donePressed(text: String)
}

class KeyboardView: UIView {
    struct DisplayModel {
        var title: String
        var desc: String
    }

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: HalfVCDelegate?
    weak var keyboardViewDelegate: KeyboardViewDelegate?
    
    var displayModel: DisplayModel?
    
    private func uiSetup() {
        registerForKeyboardNotifications()
        self.layer.cornerRadius = 15.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        doneButton.layer.cornerRadius = 7.0
        
        titleLabel.text = displayModel?.title
        descLabel.text = displayModel?.desc
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        let text = textField.text ?? ""
        keyboardViewDelegate?.donePressed(text: text)
        delegate?.dismissController(completion: nil)
    }
    
    private func registerForKeyboardNotifications()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //mark - Keyboard Notification methods
    @objc func keyboardWillShow(aNotification : NSNotification)
    {
        let info = aNotification.userInfo
        if let value = info![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = value.cgRectValue
            let keyboardSize = keyboardRect.size
            let yOriginAndHeight = self.giveSelectedKeyboardTopAndHeight()
            let heightToRise = heightToRiseTo(keyboardHeight: keyboardSize.height, textFieldEffectiveYOrigin: yOriginAndHeight.0, textFieldHeight: yOriginAndHeight.1)
            self.delegate?.keyboardShowed(moveUpByHeight: heightToRise)
        }
    }

    private func heightToRiseTo(keyboardHeight: CGFloat, textFieldEffectiveYOrigin: CGFloat, textFieldHeight: CGFloat) -> CGFloat {
        var keyboardHeightToUse = keyboardHeight
        
        if let bottomPadding = window?.safeAreaInsets.bottom {
            keyboardHeightToUse = keyboardHeightToUse - bottomPadding
        }
        let fullScreenHeight = UIScreen.main.bounds.height
        
        let heightAllowed = self.frame.height - textFieldEffectiveYOrigin
        let heightLeftAfterRise = fullScreenHeight - (heightAllowed + keyboardHeightToUse)
        var heightToRise: CGFloat = 0.0
        if heightLeftAfterRise > 0 {
            heightToRise = keyboardHeightToUse
        } else {
            heightToRise = keyboardHeightToUse - (heightLeftAfterRise) - 50//heightLeftAfterRise is negative here - (-) is given instead of + for clarity
        }
        return heightToRise
    }

    private func giveSelectedKeyboardTopAndHeight() -> (CGFloat, CGFloat) {
        if let selectedKeyboard = textField {
            return (selectedKeyboard.frame.origin.y, selectedKeyboard.frame.height)
        }
        return (CGFloat.init(0), CGFloat.init(0))
    }

    @objc func keyboardWillHide(aNotification : NSNotification)
    {
        self.delegate?.keyboardHidden()
    }
}

extension KeyboardView: HalfVCView {

    public func assignValues(_ data: Any?, delegate: HalfVCDelegate) {
        self.delegate = delegate
        if let displayModel = data as? DisplayModel {
            self.displayModel = displayModel
        }
        self.uiSetup()
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
        if let keyboardViewDelegate = delegate as? KeyboardViewDelegate {
            self.keyboardViewDelegate = keyboardViewDelegate
        }
    }
}
