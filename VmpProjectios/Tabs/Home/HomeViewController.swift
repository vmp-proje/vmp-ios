//
//  HomeViewController.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

//class HomeViewController: ViewController<MusicView> {
class HomeViewController: ViewController<HomeView> {
    
    var titleTexts: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear Çalıştı.")
        customView.getContentTitles()
        customView.getContentURL()
    }
    
  //MARK: - View Appearance
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\nHomeViewController Çalıştı.")
    customView.layoutViews() // fetchStandartPhotoUrl
    NotificationCenter.default.addObserver(self, selector: #selector(displayTitles(notification:)), name: Notification.Name(rawValue: "fetchTitlesDone"), object: nil)
    }
    
    @objc func displayTitles(notification: Notification) {
        
        let titles :[String] = notification.object as! [String]
        var i = 0
        for title in titles {
            i += 1
            print("\(title). Title -> \(title)")
        }
    }
    
}
