//
//  HomeViewController.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


//class HomeViewController: ViewController<FlowCollectionView> {
class HomeViewController: ViewController<HomeView> {
  
  var videoTitleTexts: [String] = []
  var channelTitleTexts: [String] = []
  var videoImageUrl: [String] = []
    /*
     viewWillAppear daki .done içinde print edebildiğim datayı ben nasıl collectionView metodları içine göndericem bi fikrin var mı ?
     */
  override func viewWillAppear(_ animated: Bool) {
    print("viewWillAppear Çalıştı.")
//    getContentTitles()
//    getContentURL()
//    var i = 0
    
//    print("----****----")
    
//    YoutubeManager.shared.getPopularVideos().done { (popularVideos) in
//
//        self.videoTitleTexts.reserveCapacity(popularVideos.items!.count)
//        self.channelTitleTexts.reserveCapacity(popularVideos.items!.count)
//        self.videoImageUrl.reserveCapacity(popularVideos.items!.count)
//
//        for item in popularVideos.items ?? [] {
//            print("🔥🔥🔥 title: \(item.snippet?.title) channel name: \(item.snippet?.channelTitle) photo url: \(item.snippet?.thumbnails?.standard?.url)")
//            i += 1
//        }
//    }.catch { (error) in
//      print("HomeViewController.swift getPopularVideos error: \(error)")
//    }
  }
  
  //MARK: - View Appearance
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\nHomeViewController Çalıştı.")
    
//    NotificationCenter.default.addObserver(self, selector: #selector(displayTitles(notification:)), name: Notification.Name(rawValue: "fetchTitlesDone"), object: nil)
//
//    for counter in self.videoTitleTexts {
//        print(counter)
//    }
  }
  
  @objc func displayTitles(notification: Notification) {
    
    let titles :[String] = notification.object as! [String]
    var i = 0
    for title in titles {
      i += 1
      print("\(title). Title -> \(title)")
    }
  }
  
  
  func getContentTitles() {
    self.customView.titleArray.reserveCapacity(25)
    
    let trendVideosUrl = URL(string: "https://www.googleapis.com/youtube/v3/videos")
    
    Alamofire.request(trendVideosUrl!,
                      method: .get,
                      parameters: ["part": "snippet", "chart": "mostPopular", "regionCode":"TR", "maxResults": 25, "key": youtube_access_token])
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success:
          print("Validation Successfull\n")
          if let value = response.value as? [String: Any] {
            if let items = value["items"] as? [[String: Any]] {
              for counter in 0...items.count-1 {
                let snippet = items[counter]["snippet"] as! [String: Any]
                let title = snippet["title"] as! String
                self.customView.titleArray.append(title)
                
              }
              if self.customView.titleArray.isEmpty {
                print("titleArray İçi Boş.")
              } else  {
                print("titleArray İçi Dolu.")
              }
            }
          }
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchTitlesDone"), object: self.customView.titleArray)
        case let .failure(error):
          print("\n**********\n\nBağlantı hatası: \(error)\n\n**********")
        }
    }
  }
  
  func getContentURL(){
    self.customView.urlArray.reserveCapacity(25)
    let trendVideosUrl = URL(string: "https://www.googleapis.com/youtube/v3/videos")
    // https://www.googleapis.com/youtube/v3/videos
    Alamofire.request(trendVideosUrl!,
                      method: HTTPMethod.get,
                      parameters: ["part": "snippet", "chart": "mostPopular", "regionCode":"TR", "maxResults": 25, "key": youtube_access_token])
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success:
          print("Validation Successfull\n")
          if let value = response.value as? [String: Any] {
            if let items = value["items"] as? [[String: Any]] {
              for counter in 0...items.count-1 {
                let snippet = items[counter]["snippet"] as! [String: Any]
                let thumbnails = snippet["thumbnails"] as? [String: Any]
                let standardPhoto = thumbnails!["standard"] as? [String: Any]
                let urlText = standardPhoto!["url"] as! String
                self.customView.urlArray.append(urlText)
                
              }
              if self.customView.urlArray.isEmpty {
                print("urlArray İçi Boş.")
              } else  {
                print("urlArray İçi Dolu.")
              }
              
            }
          }
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchStandartPhotoUrl"), object: self.customView.urlArray)
        case let .failure(error):
          print("\n**********\n\nBağlantı hatası: \(error)\n\n**********")
        }
    }
  }
  
}

//MARK: - Collection View

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        return cell
    }
    
    
}
