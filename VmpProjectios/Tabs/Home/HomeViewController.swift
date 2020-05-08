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
    }
    
  //MARK: - View Appearance
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\nHomeViewController Çalıştı.")
    NotificationCenter.default.addObserver(self, selector: #selector(displayTitles(notification:)), name: Notification.Name(rawValue: "fetchTitlesDone"), object: nil)
    }
    
    @objc func displayTitles(notification: Notification) {
        print("Notification HomeVC'ye ulaştı.")
        let titles :[String] = notification.object as! [String]
        for title in titles {
            print(title)
        }
    }
    
}
