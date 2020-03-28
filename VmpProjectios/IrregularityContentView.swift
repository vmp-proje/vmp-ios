import UIKit
import ESTabBarController_swift


class IrregularityContentView: ESTabBarItemContentView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    imageView.contentMode = .center
    imageView.tintColor = .appBlue
    self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.titleLabel.font = AppFont.Regular.font(size: 12)
    let transform = CGAffineTransform.identity
    self.imageView.transform = transform
    self.superview?.bringSubviewToFront(self)
    
    itemContentMode = .alwaysOriginal
    
    textColor = UIColor.gray.withAlphaComponent(0.75)
    highlightTextColor = UIColor.appBlue
    iconColor = .lightText
    highlightIconColor = UIColor.appBlue
    backdropColor = .clear
    highlightBackdropColor = .clear
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
    completion?()
  }
  
  public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
    completion?()
  }
  
  public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
    UIView.beginAnimations("small", context: nil)
    UIView.setAnimationDuration(0.2)
    let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
    self.imageView.transform = transform
    UIView.commitAnimations()
    completion?()
  }
  
  public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
    UIView.beginAnimations("big", context: nil)
    UIView.setAnimationDuration(0.2)
    let transform = CGAffineTransform.identity
    self.imageView.transform = transform
    UIView.commitAnimations()
    completion?()
  }
  
}

