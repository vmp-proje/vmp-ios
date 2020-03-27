//
//  LoginView.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class LoginView: View {
  
  //MARK: - Visual Objects
  let emailTextField = InputTextField(frame: .zero)
  let passwordTextField = InputTextField(frame: .zero)
  
  let loginbutton: UIButton = {
    let button = UIButton()
    button.setTitle("Log In".localized(), for: .normal)
    button.titleLabel?.font = AppFont.Regular.font(size: 16)
    button.layer.masksToBounds = true
    button.backgroundColor = Color.collectionViewCellBackground
    
    return button
  }()
  
  let forgotPassword: Label = {
    let label = Label(font: AppFont.Regular.font(size: 12), textColor: .lightGray, textAlignment: .right, numberOfLines: 2)
    label.isUserInteractionEnabled = true
    let text = "Forgot Password?".localized()
    
    return label
  }()
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupTextFields()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  private func setupTextFields() {
    emailTextField.textLabel.autocapitalizationType = .none
    emailTextField.placeholder = "Email Address".localized()
    passwordTextField.placeholder = "Password (8+ characters)".localized()
    passwordTextField.textLabel.autocapitalizationType = .none
    
    emailTextField.textLabel.keyboardType = UIKeyboardType.emailAddress
    passwordTextField.textLabel.isSecureTextEntry = true
  }
  
  
  //MARK: - UI
  override func setViews() {
    addSubview(emailTextField)
    addSubview(passwordTextField)
    addSubview(forgotPassword)
    addSubview(loginbutton)
  }
  
  override func layoutViews() {
    emailTextField.autoPinEdge(toSuperviewSafeArea: .top, withInset: 50)
    emailTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    emailTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    emailTextField.autoSetDimension(.height, toSize: 65)
    
    passwordTextField.autoPinEdge(.top, to: .bottom, of: self.emailTextField, withOffset: 23)
    passwordTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    passwordTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    passwordTextField.autoSetDimension(.height, toSize: 65)
    
    forgotPassword.autoPinEdge(.top, to: .bottom, of: self.passwordTextField, withOffset: 15)
    forgotPassword.autoSetDimension(.width, toSize: 118)
    forgotPassword.autoSetDimension(.height, toSize: 25)
    forgotPassword.autoPinEdge(.right, to: .right, of: self, withOffset: -23)
    
    loginbutton.autoPinEdge(.top, to: .bottom, of: self.passwordTextField, withOffset: 80)
    loginbutton.anchorCenterXToSuperview()
    loginbutton.autoSetDimension(.width, toSize: 140)
    loginbutton.autoSetDimension(.height, toSize: 58)
    loginbutton.layer.cornerRadius = 29
  }
  
}
