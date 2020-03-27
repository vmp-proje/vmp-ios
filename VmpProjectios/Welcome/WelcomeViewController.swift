//
//  WelcomeViewController.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: ViewController<WelcomeView> {
  
  
  
  //MARK: - View Appearance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customView.loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    customView.registerButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    
    let settingsVC = SettingsViewController()
    self.navigationController?.pushViewController(settingsVC, animated: true)
  }
  
  
  @objc func goToLogin() {
    let loginVC = LoginViewController()
    self.navigationController?.pushViewController(loginVC, animated: true)
  }
  
  @objc func goToRegister() {
    let registerVC = RegisterViewController()
    self.navigationController?.pushViewController(registerVC, animated: true)
    
  }
  
}
