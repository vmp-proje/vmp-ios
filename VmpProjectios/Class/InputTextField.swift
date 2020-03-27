import UIKit
import SkyFloatingLabelTextField


class InputTextField: UIView {
  
  
  //MARK: - Visual Objects
  let textLabel = FloatingTextField()
  
  private var errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }()
  
  
  //MARK: - Variables
  var placeholder: String? {
    didSet {
      self.textLabel.placeholder = self.placeholder
    }
  }
  
  var textColor = Color.appWhite {
    didSet {
      self.textLabel.textColor = self.textColor
    }
  }
  
  var errorMessageColor: UIColor! = .red {
    didSet {
      if let newColor = self.errorMessageColor {
        errorLabel.textColor = newColor
      } else {
        self.errorMessageColor = .red
      }
    }
  }
  
  var errorFont = AppFont.Regular.font(size: 12) {
    didSet {
      self.errorLabel.font = self.errorFont
    }
  }
  
  var textFont = AppFont.Regular.font(size: 12) {
    didSet {
      self.textLabel.font = self.textFont
    }
  }
  
  var errorText: String? {
    didSet {
      if let errorText = self.errorText {
        self.errorLabel.text = errorText
        self.showErrorLabel()
        self.textLabel.textColor = self.errorMessageColor
        self.textLabel.selectedLineColor = self.errorMessageColor
        self.textLabel.selectedTitleColor = self.errorMessageColor
      } else {
        self.hideErrorLabel()
        self.textLabel.textColor = self.textColor
        self.textLabel.selectedLineColor = self.textColor
        self.textLabel.selectedTitleColor = self.textColor
      }
    }
  }
  
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    loadUI()
    errorLabel.textColor = self.errorMessageColor
    errorLabel.font = self.errorFont
    textLabel.textColor = self.textColor
    self.errorLabel.alpha = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - UI
  private func showErrorLabel() {
    UIView.animate(withDuration: 0.6, delay: 0.05, options: .curveEaseInOut, animations: {
      self.errorLabel.alpha = 1
      self.errorLabel.transform = CGAffineTransform(translationX: 0, y: 7)
    }) { (isCompleted) in
    }
  }
  
  private func hideErrorLabel() {
    UIView.animate(withDuration: 0.6, delay: 0.05, options: .curveEaseInOut, animations: {
      self.errorLabel.alpha = 0
      self.errorLabel.transform = CGAffineTransform(translationX: 0, y: -7)
      self.layoutIfNeeded()
    }) { (isCompleted) in
    }
  }
  
  private func loadUI() {
    
    addSubview(textLabel)
    textLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
    textLabel.autoPinEdge(.left, to: .left, of: self)
    textLabel.autoPinEdge(.right, to: .right, of: self)
    
    addSubview(errorLabel)
    errorLabel.autoPinEdge(.left, to: .left, of: self)
    errorLabel.autoPinEdge(.right, to: .right, of: self)
    errorLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -7)
    
  }
}


class FloatingTextField: SkyFloatingLabelTextField {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    textColor = Color.appWhite
    
    lineColor = Color.appWhite.withAlphaComponent(0.42)
    selectedLineColor = Color.appWhite.withAlphaComponent(0.62)
    
    placeholderColor = Color.appWhite.withAlphaComponent(0.9)
    selectedTitleColor = Color.appWhite.withAlphaComponent(0.62)
    placeholderFont = AppFont.Regular.font(size: 11)
    font = AppFont.Regular.font(size: 18)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
