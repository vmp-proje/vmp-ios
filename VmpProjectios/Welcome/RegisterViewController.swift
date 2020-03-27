//
//  RegisterViewController.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


class RegisterViewController: ViewController<RegisterView>, UIImagePickerControllerDelegate {
  
  
  //MARK: - Constants
  let className = "SignUpViewController.swift"
  
  
  //MARK: - Variables
  var email: String? {
    return customView.emailTextField.textLabel.text
  }
  var password: String? {
    return customView.passwordTextField.textLabel.text
  }
  var firstName: String? {
    return customView.firstNameTextField.textLabel.text
  }
  var lastName: String? {
    return customView.lastNameTextField.textLabel.text
  }
  
  
  //MARK: - View Appearance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    canShowMusicPlayerPopupBar = false
    setupNavigationBar()
    //    self.customView.facebookButton.addTarget(self, action: #selector(signUpWithFacebookButtonTapped), for: .touchUpInside)
    self.customView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    
    let termLabelTap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped(gesture:)))
    self.customView.privacyLabel.addGestureRecognizer(termLabelTap)
    customView.addPhotoTextButton.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
    customView.addPhotoButton.addTarget(self, action: #selector(tapPhoto), for: .touchUpInside)
    self.customView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
  }
  
  
  //MARK: - Button Actions
  @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
    
//    let termString = customView.termText as NSString
//    let termRange = termString.range(of: customView.term)
//    let policyRange = termString.range(of: customView.privacy)
//
//    let tapLocation = gesture.location(in: self.customView.privacyLabel)
//
//    let index = customView.privacyLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
//
//    if checkRange(termRange, contain: index) == true {
//      handleViewTermOfUse()
//      return
//    }
//
//    if checkRange(policyRange, contain: index) {
//      handleViewPrivacy()
//      return
//    }
  }
  
  private func handleViewTermOfUse() {
    print("SignupViewController ->  handleViewTermOfUse() show safari")
  }
  
  private func handleViewPrivacy() {
    print("SignupViewController ->  handleViewPrivacy() -> show safari")
  }
  
  @objc func signUpButtonTapped() {
    checkEmptyFields()
    
    let alphabeticErrorMessage: String = "This field can't contain numbers".localized()
    let emailErrorMessage: String = "Invalid Email".localized()
    let passwordErrorMessage: String = "Password must be longer than 8 characters".localized()
    
    var firstNameHasError: Bool!
    var lastNameHasError: Bool!
    var emailHasError: Bool!
    var passwordHasError: Bool!
    if hasNoEmptyField() {
      if email!.isEmail {
        emailHasError = false
      } else { // error
        self.customView.emailTextField.errorText = emailErrorMessage
        emailHasError = true
      }
      if firstName!.isAlphabetic {
        firstNameHasError = false
      } else { // error
        self.customView.firstNameTextField.errorText = alphabeticErrorMessage
        firstNameHasError = true
        
      }
      if lastName!.isAlphabetic {
        lastNameHasError = false
      } else { // error
        lastNameHasError = true
        self.customView.lastNameTextField.errorText = alphabeticErrorMessage
        
      }
      if password!.count > 7 {
        passwordHasError = false
      } else { // error
        self.customView.passwordTextField.errorText = passwordErrorMessage
        passwordHasError = true
      }
      
      if firstNameHasError == false && lastNameHasError == false && emailHasError == false && passwordHasError == false { //Register
        self.register()
      }
    }
    
  }
  
  @objc func signUpWithFacebookButtonTapped() {
    print("SignupViewController -> signUpWithFacebookButtonTapped()")
  }
  
  @objc func dismissVC() {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  //MARK: - Backend
  func register() {
    //FIXME: - dummy
    NotificationCenter.default.post(name: NSNotification.Name.init("reloadApp"), object: nil)
    
//    startLoadingAnimation()
//    UserManager.shared.signUp(self.firstName!, lastName: self.lastName!, email: self.email!, password: self.password!, image: self.profileImage ).done { (user) in
//
//      self.stopLoadingAnimation()
//      self.showMainTabBarVC()
//      AppNotification.shared.userLoggedIn()
//
//    }.catch({ (error) in
//      ShowErrorMessage.statusLine(message: "\(self.className) register() Error occured: \(error)".localized())
//      self.stopLoadingAnimation()
//    })
  }
  
  private func showMainTabBarVC() {
//    let mainTabBarVC = MainTabBarController()
//    let nav = UINavigationController(rootViewController: mainTabBarVC)
//    nav.modalPresentationStyle = .fullScreen
//    self.navigationController?.present(nav, animated: true, completion: nil)
  }
  
  //MARK: - Valid Input Checker
  /// true: NO Empty Fields - false: there are empty fields
  private func hasNoEmptyField() -> Bool {
    let arr = [firstName, lastName, email, password]
    
    for text in arr {
      if text == nil || text == "" {
        return false
      }
    }
    return true
  }
  
  private func checkEmptyFields() {
    let errorMessage = "This field can't be empty".localized()
    let textFields = [customView.emailTextField, customView.passwordTextField, customView.firstNameTextField, customView.lastNameTextField]
    
    for textField in textFields {
      if textField.textLabel.text == nil || textField.textLabel.text == "" {
        textField.errorText = errorMessage
      } else {
        textField.errorText = nil
      }
    }
    
  }
  
  //MARK: - UIImagePickerControllerDelegate
  @objc func tapPhoto() {
    self.view.endEditing(true)
    
    let ac = UIAlertController(title: "Profile Photo".localized(), message: nil, preferredStyle: .actionSheet)
    
    ac.addAction(UIAlertAction(title: "Select from Album".localized(), style: .default, handler: { (action) in
      let picker = UIImagePickerController()
      picker.sourceType = .photoLibrary
      picker.allowsEditing = true
      picker.delegate = self
      picker.navigationBar.isTranslucent = false
      picker.navigationBar.barTintColor = .lightGray
      picker.navigationBar.tintColor = Color.appWhite
      picker.modalPresentationStyle = .fullScreen
      self.present(picker, animated: true)
    }))
    
    ac.addAction(UIAlertAction(title: "Take from Camera".localized(), style: .default, handler: { (action) in
      let picker = UIImagePickerController()
      picker.sourceType = .camera
      picker.allowsEditing = true
      picker.delegate = self
      picker.navigationBar.isTranslucent = false
      picker.navigationBar.barTintColor = .lightGray
      picker.navigationBar.tintColor = Color.appWhite
      picker.modalPresentationStyle = .fullScreen
      self.present(picker, animated: true)
    }))
    
    ac.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel))
    ac.popoverPresentationController?.sourceView = self.view
    ac.modalPresentationStyle = .fullScreen
    present(ac, animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  var profileImage: UIImage?
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let possibleImage = info[.editedImage] as? UIImage {
      self.customView.addPhotoButton.setImage(possibleImage, for: .normal)
      self.profileImage = possibleImage
    } else if let possibleImage = info[.originalImage] as? UIImage {
      self.customView.addPhotoButton.setImage(possibleImage, for: .normal)
      self.profileImage = possibleImage
    } else {
//      Debugger.logError(message: "\(self.className) -> imagePickerController() selected image is nil", data: 0_0)
      return
    }
    self.customView.addPhotoTextButton.setTitle("Change Photo".localized(), for: .normal)
    dismiss(animated: true)
  }
  
  
  //MARK: - UI
  private func setupNavigationBar() {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    let backButton = UIButton(type: UIButton.ButtonType.custom)
    let arrowImg = UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate)
    backButton.setImage(arrowImg, for: .normal)
    backButton.imageView?.tintColor = Color.appWhite
    backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    let backBarButton = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = backBarButton
    
    
    navigationItem.title = "Sign Up".localized()
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.appWhite, NSAttributedString.Key.font : AppFont.Bold.font(size: 18)]
  }
}
