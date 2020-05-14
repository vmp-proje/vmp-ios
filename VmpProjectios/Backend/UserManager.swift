//
//  UserManager.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit
import KeychainSwift


class AppCache {
  
  static let shared = AppCache()
  
  var mail = ""
  var username = ""
}


class UserManager {
  
  static let shared = UserManager()
  
  
  func login() {
    
  }
  
  func register(_ username:String, email:String, password:String) -> Promise<RegisterModel> {
    return Promise { seal in
      UserService.signUp(username: username, email: email, password: password).performRequest(RegisterModel.self).done { (registerModel) in
        self.saveToken(register: registerModel)
        seal.fulfill(registerModel)
      }.catch({ (error) in
        seal.reject(error)
      })
    }
  }
  
  private func saveToken(register: RegisterModel){
    guard let token = register.data?.token else {return}
    let keychain = KeychainSwift()
    keychain.set(token, forKey: "access_token")
    
    print("token saved: \(keychain.get("access_token"))")
  }
  
  func logout() {
    
  }
}
