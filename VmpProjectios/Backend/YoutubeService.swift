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

let audio_base_url = URL(string: "https://223df87c.ngrok.io/api/v1/media/audio")!


enum YoutubeService: RestService {
  
  
  case getAudio(videoId: String)
  case getMostPopularVideos
  case search(search: String)
  
  
  func url() -> URL {
    
    switch self {
    case .getAudio:
      let url = audio_base_url
      return url
    default:
      let url = youtubeBaseUrl.appendingPathComponent(self.path())
      return url
    }
  }
  
  func HTTPHeaders() -> [String: String] {
    var headers : [String:String] = [:]
    
    //    FIXME;
    //    if let user = UserManager.shared.currentUser()  {
    //      return user.authenticationHeaders()
    //    }
    
    //    var authHeaders : [String:String] = [:]
    //    authHeaders["Content-Type"] = "application/json"
    //    authHeaders["key"] = youtube_access_token
    
    //    return authHeaders
    return headers
  }
  
  func method() -> HTTPMethod {
    switch self {
    case .search:
      return .get
    case .getAudio:
      return .post
    default:
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
      //    case .search:
    //      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
    
  }
  
  func path()->String {
    switch self {
    case .search:
      return "search"
    case .getMostPopularVideos:
      return "videos"
    default:
      return ""
    }
  }
  
  func parameters() -> [String : AnyObject]? {
    var params = [String:AnyObject]()
    var data = [String:AnyObject]()
    
    
    switch self {
    case .search(search: let search):
//      return ["key": youtube_access_token as AnyObject, "type": "video" as AnyObject, "q": search as AnyObject, "part": "snippet" as AnyObject]
      return ["part": "snippet" as AnyObject, "q": search as AnyObject, "type": "video" as AnyObject, "key": youtube_access_token as AnyObject]//"maxResults": 5,
    case .getMostPopularVideos:
      return ["part": "snippet" as AnyObject, "chart": "mostPopular" as AnyObject, "regionCode":"TR" as AnyObject, "key": youtube_access_token as AnyObject] //"maxResults": 25 as! AnyObject,
      
    case .getAudio(videoId: let videoId):
      return ["videoUrl": "https://www.youtube.com/watch?v=\(videoId)" as AnyObject]
      
    default:
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

