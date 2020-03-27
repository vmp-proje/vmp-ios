//
//  WelcomeView.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class WelcomeView: View {
  
  
  let whiteBackground: UIView = {
    let bgView = UIView()
    bgView.translatesAutoresizingMaskIntoConstraints = false
    bgView.backgroundColor = UIColor.black.withAlphaComponent(0.28)
    
    return bgView
  }()
  
  let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "welcome_background")
    imageView.contentMode = .scaleAspectFill
    
    return imageView
  }()

  let termOfUseButton = Button(text: "Terms of Use".localized(), font: AppFont.Regular.font(size: 13), textColor: UIColor.gray.withAlphaComponent(0.7), textAlignment: .right, backgroundColor: .clear, highlightedTextColor: UIColor.gray)
  
  let privacyButton = Button(text: "Privacy Policy".localized(), font: AppFont.Regular.font(size: 13), textColor: UIColor.gray.withAlphaComponent(0.6), textAlignment: .right, backgroundColor: .clear, highlightedTextColor: UIColor.gray)
  
  let welcomeLabel = Label(text: "Welcome".localized(), font: AppFont.Bold.font(size: 37), textColor: .white, textAlignment: .center, numberOfLines: 1)
  let infoLabel = Label(text: "You can watch & download all the youtube videos. Please login or register to keep going.".localized(), font: AppFont.Regular.font(size: 16), textColor: .white, textAlignment: .center, numberOfLines: 0)
  
  let loginButton = Button(text: "Login".localized(), font: AppFont.Bold.font(size: 20), textColor: .white, textAlignment: .center, backgroundColor: UIColor.black.withAlphaComponent(0.5), highlightedTextColor: UIColor.lightGray)
  let registerButton = Button(text: "Register".localized(), font: AppFont.Bold.font(size: 20), textColor: .white, textAlignment: .center, backgroundColor: UIColor.black.withAlphaComponent(0.5), highlightedTextColor: UIColor.lightGray)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
    privacyButton.titleLabel?.adjustsFontSizeToFitWidth = true
    termOfUseButton.titleLabel?.adjustsFontSizeToFitWidth = true
    loadUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func loadUI() {
    addSubview(loginButton)
    loginButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 98)
    loginButton.autoPinEdge(.left, to: .left, of: self, withOffset: 30)
    loginButton.autoPinEdge(.right, to: .right, of: self, withOffset: -30)
    loginButton.autoSetDimension(.height, toSize: 46)
    loginButton.layer.cornerRadius = 23
    
    addSubview(registerButton)
    registerButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 38)
    registerButton.autoPinEdge(.left, to: .left, of: self, withOffset: 30)
    registerButton.autoPinEdge(.right, to: .right, of: self, withOffset: -30)
    registerButton.autoSetDimension(.height, toSize: 46)
    registerButton.layer.cornerRadius = 23
    
    addSubview(infoLabel)
    infoLabel.autoPinEdge(.bottom, to: .top, of: loginButton, withOffset: -36)
    infoLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 30)
    infoLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -30)
    
    addSubview(welcomeLabel)
    welcomeLabel.autoPinEdge(.bottom, to: .top, of: infoLabel, withOffset: -10)
    welcomeLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 30)
    welcomeLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -30)
    
    let stackView = UIStackView(arrangedSubviews: [privacyButton, termOfUseButton], axis: NSLayoutConstraint.Axis.horizontal, spacing: 20, alignment: UIStackView.Alignment.center, distribution: UIStackView.Distribution.fillEqually)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    stackView.autoSetDimension(.height, toSize: 15)
    stackView.anchorCenterXToSuperview()
    stackView.autoSetDimension(.width, toSize: 205)
    stackView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10)
    
    // Background
    addSubview(backgroundImageView)
    backgroundImageView.fillToSuperview()
    addSubview(whiteBackground)
    whiteBackground.fillToSuperview()
    sendSubviewToBack(whiteBackground)
    sendSubviewToBack(backgroundImageView)
  }
}
