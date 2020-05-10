//
//  YoutubeManager.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit


let youtube_access_token = "AIzaSyBQmoRsMPI8t5XibRv-suraDfYnfr0hYZE"

class YoutubeManager {
  
  
  static let shared = YoutubeManager()
//
  func search(search: String) -> Promise<PopularVideos> {
    return Promise { seal in
      YoutubeService.search(search: search).performRequest(PopularVideos.self).done { (popularVideos) in
        seal.fulfill(popularVideos)
      }.catch { (error) in
        print("YoutubeManager.swift search(search: \(search) error: \(error)")
        seal.reject(error)
      }
    }
  }
  
  
//  func search(search: String) -> Promise<String> {
//    return Promise { seal in
//      YoutubeService.search(search: search).performRequest().done { (popularVideos) in
//        seal.fulfill(popularVideos)
//      }.catch { (error) in
//        print("YoutubeManager.swift search(search: \(search) error: \(error)")
//        seal.reject(error)
//      }
//    }
//  }

  
  
  func getPopularVideos() -> Promise<PopularVideos> {
    return Promise { seal in
      YoutubeService.getMostPopularVideos.performRequest(PopularVideos.self).done { (popularVideos) in
        seal.fulfill(popularVideos)
      }.catch { (error) in
        print("YoutubeManager.swift getPopularVideos() error: \(error)")
        seal.reject(error)
      }
    }
  }
}
