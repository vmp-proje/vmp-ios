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
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
    return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
  }
  
  public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
    let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
    view.layer.cornerRadius = 1.0
    view.layer.opacity = 0.5
    view.backgroundColor = .clear
    self.addSubview(view)
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

