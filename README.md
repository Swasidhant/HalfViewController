# HalfViewController


A common View Controller for presenting developer provided views (from XIBs) from bottom with animation. Basically it can be used for semi-height views to be presented from bottom. 

![](./gif/halfvc.gif)


##Usage
Move the two files (HalfVC.swift and HalfVC.storyboard) in HalfVC folder to your project and start using them.

**1** Your custom view needs to implement ```swift HalfVCView ``` protocol

***1.1*** Details of the protocol

```swift
/********************************************/
 var delegate: HalfVCDelegate? {get}
--- your view calls methods of HalfVCDelegate through this property
 
 /*******************************************/
 func assignValues(_ data: Any?, delegate: HalfVCDelegate)
// assign the data from the VC presenting HalfVC to your view
 
//    Check example implementation in InfoView, KeyboardView, AlertExampleView, TableExampleView, TwoViewFirstView or TwoViewSecondView
 
 /*******************************************/
 func assignPresentingControllerDelegates(delegate: Any?)
//    assign reference of your presenting VC to your view
//    This is better if done through a protocol
 
//    Check example implementation in InfoView, KeyboardView, TableExampleView or TwoViewSecondView
 
 /*******************************************/
 func giveSizeWith() -> CGSize
//  gives size of your view. You can use the following:
 
  public func giveSizeWith() -> CGSize {
      self.layoutIfNeeded()
      if self.intrinsicContentSize.width < 0 || self.intrinsicContentSize.height < 0 {
          return self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      } else {
          return self.intrinsicContentSize
      }
  }
 
 /*******************************************/
 func uiSettingsOnLoad()
//  when you want to make any changes to your view after viewDidLoad of HalfViewController
```
