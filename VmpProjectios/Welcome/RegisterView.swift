//
//  RegisterView.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import TPKeyboardAvoiding

class RegisterView: View {
  
  //MARK: - Constants
  let termText = "By continuing, you agree to Metta's Terms & Conditions and Privacy Policy".localized()
  let term = "Terms & Conditions".localized()
  let privacy = "Privacy Policy".localized()
  
  
  //MARK: - Visual Objects
  let scrollView = TPKeyboardAvoidingScrollView(frame: .zero)
  let firstNameTextField = InputTextField(frame: .zero)
  let lastNameTextField = InputTextField(frame: .zero)
  let emailTextField = InputTextField(frame: .zero)
  let passwordTextField = InputTextField(frame: .zero)
  
  let addPhotoButton = RoundedIconButton(icon: UIImage(named: "account")!)
  
  let addPhotoTextButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.setTitle("Add Photo".localized(), for: .normal)
    button.titleLabel?.font = AppFont.Regular.font(size: 14)
    button.setTitleColor(Color.appWhite, for: .normal)
    
    return button
  }()

  let signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle("Get Started".localized(), for: .normal)
    button.titleLabel?.font = AppFont.Regular.font(size: 16)
    button.layer.masksToBounds = true
    button.backgroundColor = Color.collectionViewCellBackground
    
    return button
  }()
  
//  let facebookButton = FacebookButton()
  
  let privacyLabel: Label = {
    let label = Label(font: AppFont.Regular.font(size: 12), textColor: .lightGray, textAlignment: .center, numberOfLines: 0)
    label.isUserInteractionEnabled = true
    
    return label
  }()
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupTextFields()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentSize = CGSize(width: screenSize.width, height: 615+75)
    
//    let underlinedAttrStr = String.underLineAttrString(strings: [term, privacy], linkFont: AppFont.Regular.pt12, linkTextColor: .lightGray, underlineColor: .lightGray, inString: termText, font: AppFont.Regular.pt12, color: .lightGray)
//    self.privacyLabel.attributedText = underlinedAttrStr
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupTextFields() {
    firstNameTextField.placeholder = "First Name".localized()
    lastNameTextField.placeholder = "Last Name".localized()
    emailTextField.placeholder = "Email Address".localized()
    passwordTextField.placeholder = "Password (8+ characters)".localized()
    
    emailTextField.textLabel.autocapitalizationType = .none
    passwordTextField.textLabel.autocapitalizationType = .none
    
    emailTextField.textLabel.keyboardType = UIKeyboardType.emailAddress
    passwordTextField.textLabel.isSecureTextEntry = true
  }
  
  //MARK: - UI
  override func setViews() {
    addSubview(scrollView)
    
    scrollView.addSubview(addPhotoButton)
    scrollView.addSubview(addPhotoTextButton)
    scrollView.addSubview(firstNameTextField)
    scrollView.addSubview(lastNameTextField)
    scrollView.addSubview(emailTextField)
    scrollView.addSubview(passwordTextField)
    scrollView.addSubview(signUpButton)
    scrollView.addSubview(privacyLabel)
  }
  
  override func layoutViews() {
    scrollView.autoPinEdgesToSuperviewSafeArea()
    
    addPhotoButton.autoPinEdge(.top, to: .top, of: self.scrollView, withOffset: 30)
    addPhotoButton.anchorCenterXToSuperview()
    addPhotoButton.autoSetDimension(.width, toSize: 75)
    addPhotoButton.autoSetDimension(.height, toSize: 75)
    
    addPhotoTextButton.autoPinEdge(.top, to: .bottom, of: self.addPhotoButton, withOffset: 10)
    addPhotoTextButton.anchorCenterXToSuperview()
    addPhotoTextButton.autoSetDimension(.width, toSize: 100)
    addPhotoTextButton.autoSetDimension(.height, toSize: 26)
    
    firstNameTextField.autoPinEdge(.top, to: .bottom, of: self.addPhotoTextButton, withOffset: 20)
    firstNameTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    firstNameTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    firstNameTextField.autoSetDimension(.height, toSize: 65)
    
    lastNameTextField.autoPinEdge(.top, to: .bottom, of: self.firstNameTextField, withOffset: 23)
    lastNameTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    lastNameTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    lastNameTextField.autoSetDimension(.height, toSize: 65)
    
    emailTextField.autoPinEdge(.top, to: .bottom, of: self.lastNameTextField, withOffset: 23)
    emailTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    emailTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    emailTextField.autoSetDimension(.height, toSize: 65)
    
    passwordTextField.autoPinEdge(.top, to: .bottom, of: self.emailTextField, withOffset: 23)
    passwordTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    passwordTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    passwordTextField.autoSetDimension(.height, toSize: 65)
    
    signUpButton.autoPinEdge(.top, to: .bottom, of: self.passwordTextField, withOffset: 30)
    signUpButton.anchorCenterXToSuperview()
    signUpButton.autoSetDimension(.width, toSize: 150)
    signUpButton.autoSetDimension(.height, toSize: 60)
    signUpButton.layer.cornerRadius = 29
    
    privacyLabel.autoPinEdge(.top, to: .bottom, of: signUpButton, withOffset: 20)
    privacyLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    privacyLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    privacyLabel.autoSetDimension(.height, toSize: 45)
  }
}

func checkRange(_ range: NSRange, contain index: Int) -> Bool {
  return index > range.location && index < range.location + range.length
}




class RoundedIconButton: UIButton {
  
  override open var isHighlighted: Bool {
    didSet {
      tintColor = isHighlighted ? Color.appWhite.withAlphaComponent(0.7) : Color.appWhite
    }
  }
  
  init(icon: UIImage?) {
    super.init(frame: .zero)
    
    self.setImage(icon?.withRenderingMode(.alwaysTemplate), for: .normal)
    translatesAutoresizingMaskIntoConstraints = false
    layer.masksToBounds = true
    tintColor = Color.appWhite
    backgroundColor = Color.collectionViewCellBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = frame.width / 2
  }
}
