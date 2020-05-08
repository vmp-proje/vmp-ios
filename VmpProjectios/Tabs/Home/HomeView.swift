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
    var urlArray : [String] = []

    //MARK: - Visual Objects
    let welcomeText: UITextView = {
        var customTextView = UITextView()
        customTextView.translatesAutoresizingMaskIntoConstraints = false
        customTextView.textColor = .black
        customTextView.font = .systemFont(ofSize: 35)
        customTextView.backgroundColor = .clear
        customTextView.text = "Welcom Home Page"
        return customTextView
    }()


    //MARK: - Initialization
    override init(frame: CGRect) {
    super.init(frame: frame)
    print("HomeView Çalıştı")
    layoutViews()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  
    //MARK: - Visual Objects
    override func setViews() {
    
    }
  
    override func layoutViews() {
        addSubview(welcomeText)
        
        welcomeText.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        welcomeText.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        welcomeText.heightAnchor.constraint(equalToConstant: 65).isActive = true
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
    
    func getContentURL(){
        self.urlArray.reserveCapacity(25)
        let trendVideosUrl = URL(string: "https://www.googleapis.com/youtube/v3/videos")
        // https://www.googleapis.com/youtube/v3/videos
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
                                let thumbnails = snippet["thumbnails"] as? [String: Any]
                                let standardPhoto = thumbnails!["standard"] as? [String: Any]
                                let urlText = standardPhoto!["url"] as! String
                                self.urlArray.append(urlText)
                                
                            }
                            if self.urlArray.isEmpty {
                                print("urlArray İçi Boş.")
                            } else  {
                                print("urlArray İçi Dolu.")
                            }
                            
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchStandartPhotoUrl"), object: self.urlArray)
                case let .failure(error):
                    print("\n**********\n\nBağlantı hatası: \(error)\n\n**********")
                }
        }
    }
    
}
