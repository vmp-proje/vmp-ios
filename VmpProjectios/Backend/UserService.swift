//
//  UserService.swift
//  VmpProjectios
//
//  Created by Anil Joe on 14.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftMessages


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

public enum UserServiceError:Error {
  case userAlreadySignUp
  case userPasswordNotMatch
  case userInvalidCredentials
  case userTokenNotValidated
  case userRegisterFailed
  case userLoginFailed
}

let baseUrl = URL(string: "https://223df87c.ngrok.io/api/v1/")!
//let register_BaseUrl = URL(string: "https://f77f2581.ngrok.io/api/v1/")!

enum UserService: RestService {
  
  
  case signUp(username:String,  email:String, password:String)
  case signIn(username: String, password: String)
  
  func url() -> URL {
//    switch self {
      let url = baseUrl.appendingPathComponent(self.path())
      return url
//    case .signUp:
//      let url = register_BaseUrl.appendingPathComponent(self.path())
//      return url
//    }
  }
  
  func HTTPHeaders() -> [String: String] {
    let headers : [String:String] = [:]
    
    switch self {
    case .signUp:
      return headers
    case .signIn:
      return headers
    }
    
  }
  
  func keyPath() -> String? {
    switch self {
    case .signIn, .signUp:
      //return "user"
      return ""
      //return nil
      //    case .forgotPassword,.updateFCM,.signOut, .applyPromotionCode, .selfUser, .singleUser, .getMonthlyActivity, .getWeeklyActivity, .update:
      return ""
    default:
      return "data"
    }
  }
  
  func method() -> HTTPMethod {
    return .post
  }
  
  func parameterEncoding() -> ParameterEncoding {
    switch self {
    case .signIn:
      return JSONEncoding.default
    case .signUp:
//      return URLEncoding.default
      return JSONEncoding.default
    }
  }
  
  func path() -> String {
    switch self {
    case .signUp:
      return "user/register"
    case .signIn:
      return "user/login"
    }
  }
  
  func parameters() -> [String : AnyObject]?  {
    var params = [String:AnyObject]()
    var data = [String:AnyObject]()
    
    switch self  {
    case .signUp(username: let username, email: let email, password: let password):
      params["username"] = username as AnyObject
      params["mail"] = email as AnyObject
      params["password"] = password as AnyObject
      return params
    case .signIn(username: let username, password: let password):
      params["email"] = username as AnyObject
      params["password"] = password as AnyObject
      //        return params
      //      data["user"] = params as AnyObject
      //      return data
    }
    return params
  }
  
  
  //    func errorTranslator(error: ErrorType?, response: NSData?, httpResponse: NSHTTPURLResponse?) -> ErrorType?
  func errorTranslator(_ errorType: Error?, response: Data?, httpResponse: HTTPURLResponse?) -> Error? {
    //    print("httpResponse?.statusCode: \(httpResponse?.statusCode)")
    if httpResponse?.statusCode == 200 {
      return nil
    }
    //    if httpResponse?.statusCode>=200 && httpResponse?.statusCode<400 {
    //      return nil
    //    }
    //    print("\n\n httpResponse.statusCode: \(httpResponse?.statusCode)")
    
    if let response = response,
      let responseStr = String(data: response, encoding: String.Encoding.utf8),
      let mappedObject = Mapper<BaseResponse>().map(JSONString: responseStr) {
      if mappedObject.hasError() {
        switch self {
        case .signUp:
          ShowErrorMessage.statusLine(message: mappedObject.errorString(nil) ?? "")
          return UserServiceError.userRegisterFailed
          
        case .signIn:
          if httpResponse?.statusCode == 401 {
            ShowErrorMessage.statusLine(message: "Invalid User Credentials")
            return UserServiceError.userInvalidCredentials
          }
          //        case .validateToken:
          //          if httpResponse?.statusCode == 401 {
          //            return UserServiceError.userInvalidCredentials
        //          }
        default:
          return nil
        }
      }
    }
    return nil
  }
  
}



class BaseResponse : Mappable {
  var status : String?
  var errors : Dictionary<String,Array<String>>?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    status            <- map["status"]
    errors            <- map["errors"]
  }
  
  func hasError() -> Bool {
    
    guard status != nil else { return true }
    return self.status == "error"
  }
  
  func errorString(_ key: String?) -> String? {
    
    var keyName : String = "full_messages"
    if let k = key {
      keyName = k
    }
    
    if let err = self.errors?[keyName] {
      if err.count > 0 {
        return err[0]
      }
    }
    return nil
  }
}



class ShowErrorMessage {
  static let sharedInstance = ShowErrorMessage()
  
  class func statusLine(message: String) {
    
    let view = MessageView.viewFromNib(layout: MessageView.Layout.cardView)
    
    // Theme message elements with the warning style.
    view.configureTheme(Theme.error)
    view.titleLabel?.isHidden = true
    view.iconLabel?.isHidden = true
    view.iconImageView?.isHidden = true
    view.button?.isHidden = true
    view.configureDropShadow()
    view.configureContent(body: message )
    
    // Customize config using the default as a base.
    var config = SwiftMessages.defaultConfig
    config.presentationStyle = .top
    config.presentationContext = .window(windowLevel: .statusBar)
    SwiftMessages.show(config: config, view: view)
    
    //      Haptic.notification(.error).generate()
  }
  
}

class ShowSuccessMessage {
  static let sharedInstance = ShowSuccessMessage()
  
  class func statusLine(message: String) {
    
    let view = MessageView.viewFromNib(layout: MessageView.Layout.cardView)
    
    // Theme message elements with the warning style.
    view.configureTheme(Theme.success)
    view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    view.titleLabel?.isHidden = true
    view.iconLabel?.isHidden = true
    view.iconImageView?.isHidden = true
    view.button?.isHidden = true
    view.configureDropShadow()
    view.configureContent(body: message )
    
    // Customize config using the default as a base.
    var config = SwiftMessages.defaultConfig
    config.presentationStyle = .top
    config.presentationContext = .window(windowLevel: .statusBar)
    SwiftMessages.show(config: config, view: view)
    
    //      Haptic.notification(.success).generate()
    
  }
  
  
  class func center(message: String) {
    
    let view = MessageView.viewFromNib(layout: MessageView.Layout.centeredView)
    
    // Theme message elements with the warning style.
    view.configureTheme(Theme.success)
    view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    view.titleLabel?.isHidden = true
    view.iconLabel?.isHidden = true
    view.iconImageView?.isHidden = true
    view.button?.isHidden = true
    view.configureDropShadow()
    view.configureContent(body: message )
    
    // Customize config using the default as a base.
    var config = SwiftMessages.defaultConfig
    config.presentationStyle = .center
    config.presentationContext = .window(windowLevel: .statusBar)
    SwiftMessages.show(config: config, view: view)
    
    //      Haptic.notification(.success).generate()
    
  }
  
  //    class func forever(message: String) {
  //
  //        let view = MessageView.viewFromNib(layout: MessageView.Layout.centeredView)
  //
  //        // Theme message elements with the warning style.
  //        view.configureTheme(Theme.success)
  //        view.titleLabel?.isHidden = true
  //        view.iconLabel?.isHidden = true
  //        view.iconImageView?.isHidden = true
  //        view.button?.isHidden = true
  //        view.configureDropShadow()
  //        view.configureContent(body: message )
  //
  //        // Customize config using the default as a base.
  //        var config = SwiftMessages.defaultConfig
  //        config.duration = .forever
  //        config.presentationStyle = .center
  //        config.presentationContext = .window(windowLevel: .statusBar)
  //        SwiftMessages.show(config: config, view: view)
  //
  //        Haptic.notification(.success).generate()
  //
  //    }
  
//}

}
