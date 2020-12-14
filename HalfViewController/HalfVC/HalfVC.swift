//
//  HalfVC.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 08/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

public protocol HalfVCDelegate: class {
    func dismissController(completion: (() -> Void)?)
    func loadNewXib(xibName: String, bundle: Bundle, data: Any?)
    func keyboardShowed(moveUpByHeight: CGFloat)
    func keyboardHidden()
    func showAlert(title: String, message: String)
}

public protocol HalfVCView: class {
    var delegate: HalfVCDelegate? {get}
    func assignValues(_ data: Any?, delegate: HalfVCDelegate)
    func assignPresentingControllerDelegates(delegate: Any?)
    func giveSizeWith() -> CGSize
    func uiSettingsOnLoad()
}

extension HalfVCView {
    func assignPresentingControllerDelegates(delegate: Any?) {}
    func uiSettingsOnLoad() {}
}

final class HalfViewController: UIViewController {
    //these two are added so that while dismissing user does not see the background VC's view
    //while HalfViewController is being dismissed we make containerBottomView bgColor same as the contained view's bgColor
    @IBOutlet weak fileprivate var containerBottomVwHt: NSLayoutConstraint!
    @IBOutlet weak fileprivate var containerBottomView: UIView!
    
    @IBOutlet weak fileprivate var bottomInsetView: UIView!
    @IBOutlet weak private var constraintContainerToBottom: NSLayoutConstraint!
    @IBOutlet weak fileprivate var backgroundView: UIView!
    @IBOutlet weak private var constraintContainerHeight: NSLayoutConstraint!
    @IBOutlet weak fileprivate var viewContainer: UIView!
    
    private var xibName: String?
    private var data: Any?
    private var bundle: Bundle?
    
    //MARK: properties for configuration of HalfViewController
    weak var halfViewDelegate: AnyObject?
    var bgColor: UIColor?
    var dismissOnOutsideTap: Bool = true
    var maxHeight: CGFloat?
    
    //MARK: method to instantiate HalfViewController
    static func controller(xibName: String, bundle: Bundle, data: Any?) -> HalfViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "HalfVC", bundle: Bundle.main) as UIStoryboard
        let controller = storyboard.instantiateViewController(withIdentifier: "HalfViewController") as! HalfViewController
        controller.bundle = bundle
        controller.xibName = xibName
        controller.data = data
        controller.setTransitionDelegate()
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignUIAndData()
        self.setUpDismissGestureIfNeeded()
        
        for view in viewContainer.subviews where view is HalfVCView {
            (view as! HalfVCView).uiSettingsOnLoad()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.setContainerHeight()
        }
    }
    
    private func setContainerHeight() {
        if let height = self.giveHalfViewHeight() {
            self.constraintContainerHeight.constant = height
        }
    }
    
    fileprivate func giveHalfViewHeight() -> CGFloat? {
        if let subview: UIView = self.viewContainer.subviews.first, subview is HalfVCView {
            let size = (subview as! HalfVCView).giveSizeWith()
            var heightToSet = size.height
            if let maxHeight = self.maxHeight, maxHeight < size.height {
                heightToSet = maxHeight
            }
            return heightToSet
        }
        return nil
    }
    
    private func setTransitionDelegate() {
        self.transitioningDelegate = self
    }
    
    private func setUpDismissGestureIfNeeded() {
        if dismissOnOutsideTap == true {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
            self.backgroundView.addGestureRecognizer(gestureRecognizer)
        }
    }

    private func assignUIAndData() {
        if let xibName = self.xibName, let bundle = self.bundle, let view = bundle.loadNibNamed(xibName, owner: nil, options: nil)![0] as? UIView, let _ = view as? HalfVCView {
            self.viewContainer.addSubview(view)
            self.bottomInsetView.backgroundColor = view.backgroundColor
            self.assignConstraintsTo(view)
            (view as! HalfVCView).assignValues(self.data, delegate: self)
            (view as! HalfVCView).assignPresentingControllerDelegates(delegate: self.halfViewDelegate)
        }
        self.backgroundView.backgroundColor = self.bgColor
    }
    
    private func assignConstraintsTo(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view])
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view])
        
        self.viewContainer.addConstraints(verticalConstraints)
        self.viewContainer.addConstraints(horizontalConstraints)
    }
    
    @objc private func viewTapped(gesture: UIGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if !self.viewContainer.frame.contains(point) {
            self.dismiss()
        }
    }
    
    private func dismiss(completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
}

//MARK: HalfVCDelegate delegate implementation
extension HalfViewController: HalfVCDelegate {
    //when we need to dismiss controller
    func dismissController(completion: (() -> Void)? = nil) {
        self.dismiss(completion: completion)
    }
    
    //when we need to show a new XIB in place of the current XIB
    func loadNewXib(xibName: String, bundle: Bundle, data: Any?) {
        self.xibName = xibName
        self.data = data
        self.bundle = bundle
        for subview in self.viewContainer.subviews {
            subview.removeFromSuperview()
        }
        
        let animation = CATransition.init()
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fillMode = CAMediaTimingFillMode.forwards;
        animation.isRemovedOnCompletion = true
        animation.type = CATransitionType.moveIn
        animation.subtype = CATransitionSubtype.fromTop
        self.viewContainer.layer.add(animation, forKey:"animation")
        
        self.assignUIAndData()
    }
    
    //when keyboard is to be presented
    func keyboardShowed(moveUpByHeight: CGFloat) {
        //TODO: check this case later and remove extra check
        self.constraintContainerToBottom.constant = 0
        self.view.layoutIfNeeded()
        
        self.constraintContainerToBottom.constant += moveUpByHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //when keyboard is to be dismissed
    func keyboardHidden() {
        self.constraintContainerToBottom.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //to show alert
    func showAlert(title: String, message: String) {
        self.showAlert(title: title, msg: message)
    }
}

//MARK: UIViewControllerTransitioningDelegate delegate methods
extension HalfViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: HalfViewShowAnimator = HalfViewShowAnimator()
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator: HalfViewDismissAnimator = HalfViewDismissAnimator()
        return animator
    }
}

//MARK: show UIViewControllerAnimatedTransitioning Animator
class HalfViewShowAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) as? HalfViewController, let backgroundView = toVC.backgroundView, let viewContainer = toVC.viewContainer, let containerBtmView = toVC.containerBottomView, let bottomInsetView = toVC.bottomInsetView else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()
        backgroundView.alpha = 0
        containerBtmView.alpha = 0
        bottomInsetView.alpha = 0
        
        var height = toVC.giveHalfViewHeight()
        height = height == nil ? viewContainer.frame.height : height
        
        //TODO: 50 is added as buffer for some views we are not getting proper height initially and hence containerView
        //shows a litte at the bottom and then animates to its place
        //This buffer can be increased if needed
        //This buffer will be removed once we find a more proper solution as to why we are not getting the proper height initially
        viewContainer.transform = CGAffineTransform.init(translationX: 0, y: height! + toVC.view.safeAreaInsets.bottom + 50.0)

        UIView.animate(withDuration: 0.2, animations: {
            backgroundView.alpha = 1
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                viewContainer.transform = CGAffineTransform.identity
                containerBtmView.alpha = 1
                bottomInsetView.alpha = 1
            }) { (innerCompleted) in
                transitionContext.completeTransition(innerCompleted)
            }
        }
    }
}

//MARK: dismiss UIViewControllerAnimatedTransitioning Animator
class HalfViewDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? HalfViewController, let _ = transitionContext.viewController(forKey: .to), let backgroundView = fromVC.backgroundView, let viewContainer = fromVC.viewContainer, let bottomInsetView = fromVC.bottomInsetView  else {
            return
        }
        //while HalfViewController is being dismissed we make containerBottomView bgColor same as the contained view's bgColor
        if !viewContainer.subviews.isEmpty {
            let addedSubview = viewContainer.subviews[0]
            fromVC.containerBottomView.backgroundColor = addedSubview.backgroundColor
        }
        UIView.animate(withDuration: 0.2, animations: {
            viewContainer.transform = CGAffineTransform.init(translationX: 0, y: -fromVC.containerBottomVwHt.constant)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                viewContainer.transform = CGAffineTransform.init(translationX: 0, y: viewContainer.frame.height + fromVC.view.safeAreaInsets.bottom)
                fromVC.containerBottomView.alpha = 0
                bottomInsetView.alpha = 0
            }) { (innerCompleted) in
                UIView.animate(withDuration: 0.2, animations: {
                    backgroundView.alpha = 0
                }) { (innerFinished) in
                    transitionContext.completeTransition(innerFinished)
                }
            }
        }
    }
}

//MARK: UIViewController extension to show alerts
extension UIViewController {
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
