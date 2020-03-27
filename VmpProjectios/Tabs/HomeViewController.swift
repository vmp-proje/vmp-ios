//
//  HomeViewController.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: ViewController<MusicView> {
  
  
  //MARK: - View Appearance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
}
