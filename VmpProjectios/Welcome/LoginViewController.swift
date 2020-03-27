//
//  LoginViewController.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: ViewController<LoginView> {
  
  
  //MARK: - Constants
  let className = "LoginViewController ->"
  
  
  //MARK: - Variables
  var email: String? {
    return self.customView.emailTextField.textLabel.text
  }
  var password: String? {
    return self.customView.passwordTextField.textLabel.text
  }
  
  
  //MARK: - View Appearance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
//    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    canShowMusicPlayerPopupBar = false
    
    setupNavigationBar()
    self.customView.loginbutton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    
    let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(handleForgotPasswordTapped(gesture:)))
    self.customView.forgotPassword.addGestureRecognizer(forgotPasswordTap)
  }
  
  
  //MARK: - Button Actions
  @objc func handleForgotPasswordTapped(gesture: UITapGestureRecognizer) {
    let forgotPasswordVC = ForgotPasswordViewController()
    self.navigationController?.pushViewController(forgotPasswordVC)
  }
  
  @objc func loginButtonTapped() {
    // Check inputs
    checkEmptyFields()
    
    if hasNoEmptyField() {
      let emailErrorMessage: String = "Invalid Email".localized()
      if email!.isEmail {
        self.customView.emailTextField.errorMessageColor = nil
        login(email: self.email!, password: self.password!)
      } else { ///error
        self.customView.emailTextField.errorText = emailErrorMessage
      }
    }
  }

  
  @objc func dismissVC() {
    //        self.dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
  }
  
  
  //MARK: - Valid Input Checker
  /// true: NO Empty Fields - false: there are empty fields
  private func hasNoEmptyField() -> Bool {
    let arr = [email, password]
    
    for text in arr {
      if text == nil || text == "" {
        return false
      }
    }
    return true
  }
  
  private func checkEmptyFields() {
    
    let errorMessage = "This field can't be empty".localized()
    let textFields = [customView.emailTextField, customView.passwordTextField]
    
    for textField in textFields {
      if textField.textLabel.text == nil || textField.textLabel.text == "" {
        textField.errorText = errorMessage
      } else {
        textField.errorText = nil
      }
    }
  }
  
  
  //MARK: - Backend
  private func login(email: String, password: String) {
//    startLoadingAnimation()
    
//    UserManager.shared.login(email, password: password).done { (user) in
//      self.stopLoadingAnimation()
//
//      self.showMainTabBarVC()
//      AppNotification.shared.userLoggedIn()
//
    NotificationCenter.default.post(name: NSNotification.Name.init("reloadApp"), object: nil)
//    }.catch({ (error) in
//      self.stopLoadingAnimation()
//      Debugger.logError(message: "\(self.className) login failed", data: error)
//    })

  }
  
  private func showMainTabBarVC() {
//    let mainTabBarVC = MainTabBarController()
//    let nav = UINavigationController(rootViewController: mainTabBarVC)
//    nav.modalPresentationStyle = .fullScreen
//    self.navigationController?.present(nav, animated: true, completion: nil)
  }
  
  
  //MARK: - UI
  private func setupNavigationBar() {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    let backButton = UIButton(type: UIButton.ButtonType.custom)
    backButton.setTitleColor(Color.appWhite, for: .normal)
    let arrowImg = UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate)
    backButton.setImage(arrowImg, for: .normal)
    backButton.imageView?.tintColor = Color.appWhite
    backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    let backBarButton = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = backBarButton
    
    navigationItem.title = "Login".localized()
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.appWhite, NSAttributedString.Key.font : AppFont.Bold.font(size: 18)]
  }
  
}
