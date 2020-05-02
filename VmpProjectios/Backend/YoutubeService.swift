//
//  YoutubeService.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


let youtubeBaseUrl = URL(string: "https://www.googleapis.com/youtube/v3/")!

enum YoutubeService: RestService {
    
  
  case getPurposes
  
  func url() -> URL {
    let url = youtubeBaseUrl.appendingPathComponent(self.path())
    return url
  }
  
  func HTTPHeaders() -> [String: String] {
    var headers : [String:String] = [:]
    
    //FIXME;
//    if let user = UserManager.shared.currentUser()  {
//      return user.authenticationHeaders()
//    }
    
    return headers
  }
  
  func method() -> HTTPMethod {
    switch self {
    case .getPurposes:
      return .get
    }
  }
  
  func keyPath() -> String?{
    switch self {
    default:
      return nil;
    }
  }
  
  func parameterEncoding() -> ParameterEncoding{
    switch self {
    case .getPurposes:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
    
  }
  
  func path()->String{
    switch self {
    case .getPurposes:
      return "purposes"
    }
  }
  
  func parameters() -> [String : AnyObject]? {
    var params = [String:AnyObject]()
    var data = [String:AnyObject]()
    
    switch self {
    case .getPurposes:
      return nil
    }
    
  }
  
  func errorTranslator(_ errorType: Error?, response: Data?, httpResponse: HTTPURLResponse?) -> Error? {
    if httpResponse?.statusCode ?? 200 >= 200 && httpResponse?.statusCode ?? 200 < 400 {
      return nil
    }
    
//    if let response = response,
//       let responseStr = String(data: response, encoding: String.Encoding.utf8),
//       let mappedObject = Mapper<BaseResponse>().map(JSONString: responseStr) {
      
//      if mappedObject.hasError() {
//        print("PurposeService -> errorTranslator -> mappedObject.hasError()")
//      }
//    }
    return nil
  }
}

