//
//  MusicPlayerBlurryBackgroundImageView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 22.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
class MusicPlayerBlurryBackgroundImageView: UIView {
  

  //MARK: - Visual Objects
  var blurEffectView = BlurEffect(frame: .zero)
  let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    
    return imageView
  }()
  
  let blackView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Color.appWhiteBlurryBackground.withAlphaComponent(0.5)
    
    return view
  }()
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    
    loadUI()
    
    blurEffectView.colorTint = .gray
    blurEffectView.colorTintAlpha = 0.18
    blurEffectView.blurRadius = 15
    blurEffectView.scale = 13
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - UI
  private func loadUI() {
    addSubview(backgroundImageView)
    addSubview(blackView)
    addSubview(blurEffectView)
    
    backgroundImageView.fillToSuperview()
    blackView.fillToSuperview()
    blurEffectView.fillToSuperview()
  }
}

