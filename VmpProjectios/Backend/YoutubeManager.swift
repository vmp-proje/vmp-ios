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

//
//let youtube_access_token = "AIzaSyBQmoRsMPI8t5XibRv-suraDfYnfr0hYZE"
//let youtube_access_token = "AIzaSyDCx26FQV1ZTR5Y6oLGdE2KeQd8on5bVE8"
//let youtube_access_token = "AIzaSyDis0J35ZeE1GmAyo-MXNlm_t5u7yMRj7w" //Worked for search
//let youtube_access_token = "AIzaSyDTc8XIi1hjiY0pEyEm6hBLcDKw6VVXC8M" //Guncel
let youtube_access_token = "AIzaSyDoPDT0txr0CvxS_GLoD0SpXxuz10OmPYo"
//https://www.googleapis.com/youtube/v3/search?part=snippet&q=Sylosis&type=video&key=AIzaSyDis0J35ZeE1GmAyo-MXNlm_t5u7yMRj7w

class YoutubeManager {
  
  
  static let shared = YoutubeManager()
//
  func search(search: String) -> Promise<SearchVideos> {
    return Promise { seal in
      YoutubeService.search(search: search).performRequest(SearchVideos.self).done { (popularVideos) in
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
