//
//  HomeView.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


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
  
}
