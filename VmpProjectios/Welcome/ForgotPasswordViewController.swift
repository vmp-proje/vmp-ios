//
//  ForgotPasswordViewController.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


class ForgotPasswordViewController: ViewController<ForgotPaswordView> {
  
  
  //MARK: - Constants
  let className = "PasswordRecoveryViewController ->"
  
  
  //MARK: - Variables
  var email: String? {
    return self.customView.emailTextField.textLabel.text
  }
  
  
  //MARK: - View Appearance
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    self.customView.sendEmailButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
  }
  
  
  //MARK: - Button Actions
  @objc func sendButtonTapped() {
    if email == nil || email == "" {
      self.customView.emailTextField.errorText = "This field can't be empty".localized()
    } else {
      let emailErrorMessage: String = "Invalid Email".localized()
      if email!.isEmail {
        self.customView.emailTextField.errorText = nil
        
        self.resetPassword(email: email!)
        
      } else { ///error
        self.customView.emailTextField.errorText = emailErrorMessage
      }
    }
  }
  
  @objc func dismissVC() {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  //MARK: - Backend
  private func resetPassword(email: String) {
//    startLoadingAnimation()
//
//    UserManager.shared.forgotPassword(email).done { (resetPassword) in
//
//      self.stopLoadingAnimation()
//
//      //Success
//      if resetPassword.success == true {
//        var message = "We sent you email. Please check your inbox.".localized()
//        if let systemMessage = resetPassword.message {
//          message = systemMessage
//        }
//
//        self.customView.infoLabel.text = self.customView.emailSentMessage
//        ShowSuccessMessage.statusLine(message: message)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//          self.dismissVC()
//        }
//
//        //Failed
//      } else {
//        ShowErrorMessage.statusLine(message: "Error: \(resetPassword.message ?? "")".localized())
//        self.customView.infoLabel.text = self.customView.willSendEmailMessage
//      }
//
//    }.catch { (error) in
//      self.stopLoadingAnimation()
//      ShowErrorMessage.statusLine(message: "Error Occured: \(error)".localized())
//      self.customView.infoLabel.text = self.customView.willSendEmailMessage
//    }
  }
  
  private func changePassword(password: String, passwordConfirmation: String) {
//    startLoadingAnimation()
//    UserManager.shared.updatePassword(password, password_confirmation: passwordConfirmation).done { (changePassword) in
//      self.stopLoadingAnimation()
//
//      if changePassword.success == true {
//        //TODO: - yapilacaklari yap
//      } else {
//
//        //TODO: - yapilacaklari yap.
//        ShowErrorMessage.statusLine(message: "Error: \(changePassword.message ?? "")".localized())
//      }
//
//    }.catch { (error) in
//      self.stopLoadingAnimation()
//      ShowErrorMessage.statusLine(message: "Error Occured: \(error)".localized())
//    }
  }
  
  //MARK: - UI
  private func setupNavigationBar() {
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    let backButton = UIButton(type: UIButton.ButtonType.custom)
    backButton.setTitleColor(Color.appWhite, for: .normal)
    let arrowImg = UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate)
    backButton.setImage(arrowImg, for: .normal)
    backButton.imageView!.tintColor = Color.appWhite
    backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    let backBarButton = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = backBarButton
    
    
    navigationItem.title = "Password Recovery".localized()
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.appWhite, NSAttributedString.Key.font : AppFont.Bold.font(size: 18)]
  }
  
}
