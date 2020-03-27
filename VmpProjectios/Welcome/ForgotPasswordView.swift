//
//  ForgotPasswordView.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class ForgotPaswordView: View {
  
  
  //MARK: - Visual Objects
  let emailTextField = InputTextField(frame: .zero)
  
  let sendEmailButton: Button = {
    let button = Button()
    button.setTitle("Send".localized(), for: .normal)
    button.titleLabel?.font = AppFont.Regular.font(size: 16)
    
    return button
  }()
  
  
  let emailSentMessage = "We sent you email. Please check your inbox.".localized()
  let willSendEmailMessage = "No worries, we will send you a link to reset you password.".localized()
  
  let infoLabel = Label(text: "No worries, we will send you a link to reset you password.".localized(), font: AppFont.Regular.font(size: 12), textColor: .lightGray, textAlignment: .center)
  
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    infoLabel.numberOfLines = 0
    setupTextFields()
//    layer.contents = UIImage(named: "signupBG")!.cgImage
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setupTextFields() {
    emailTextField.placeholder = "Email Address".localized()
    emailTextField.textLabel.autocapitalizationType = .none
    emailTextField.textLabel.keyboardType = UIKeyboardType.emailAddress
    //        emailTextField.errorMessage = "Please enter a valid e-mail adress.".localized()
  }
  
  //MARK: - UI
  func layoutEmailView() {
    addSubview(emailTextField)
    addSubview(infoLabel)
    addSubview(sendEmailButton)
    emailTextField.autoPinEdge(toSuperviewSafeArea: .top, withInset: 50)
    emailTextField.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    emailTextField.autoPinEdge(.right, to: .right, of: self, withOffset: -24)
    emailTextField.autoSetDimension(.height, toSize: 65)
    
    infoLabel.autoPinEdge(.top, to: .bottom, of: self.emailTextField, withOffset: 10)
    infoLabel.autoSetDimension(.height, toSize: 50)
    infoLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -24)
    infoLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    
    sendEmailButton.autoPinEdge(.top, to: .bottom, of: self.infoLabel, withOffset: 36)
    sendEmailButton.anchorCenterXToSuperview()
    sendEmailButton.autoSetDimension(.width, toSize: 112)
    sendEmailButton.autoSetDimension(.height, toSize: 50)
  }
  
  override func layoutViews() {
    layoutEmailView()
  }
}

