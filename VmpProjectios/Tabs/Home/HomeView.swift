//
//  HomeView.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeView: View {
  
  
  //MARK: - Variables
  let homeVC = HomeViewController()
  var titleArray : [String] = []
  //MARK: - Visual Objects
  
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    print("HomeView Çalıştı")
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - Visual Objects
  override func setViews() {
    
  }
  
  override func layoutViews() {
    
  }
        
    func getContentTitles(){
        self.titleArray.reserveCapacity(25)
        let trendVideosUrl = URL(string: "https://www.googleapis.com/youtube/v3/videos")
        Alamofire.request(trendVideosUrl!,
                          method: HTTPMethod.get,
                          parameters: ["part": "snippet", "chart": "mostPopular", "regionCode":"TR", "maxResults": 25, "key": "AIzaSyBQmoRsMPI8t5XibRv-suraDfYnfr0hYZE"])
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
                                self.titleArray.append(title)
                                
                            }
                            if self.titleArray.isEmpty {
                                print("titleArray İçi Boş.")
                            } else  {
                                print("titleArray İçi Dolu.")
                            }
                            
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchTitlesDone"), object: self.titleArray)
                case let .failure(error):
                    print("\n**********\n\nBağlantı hatası: \(error)\n\n**********")
                }
        }
    }
    
}
