//
//  AppButton.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


class Button: UIButton {
  
  
  init(text: String, font: UIFont?, textColor: UIColor?, textAlignment: NSTextAlignment?, backgroundColor: UIColor, highlightedTextColor: UIColor?) {
    super.init(frame: .zero)
    
    self.titleLabel?.font = font ?? AppFont.Regular.font(size: 12)
    self.titleLabel?.textColor = textColor ?? .white
    self.titleLabel?.textAlignment = textAlignment ?? .center
    self.backgroundColor = backgroundColor
    
    self.setTitle(text, for: .normal)
    self.setTitleColor(highlightedTextColor ?? textColor ?? .white, for: .highlighted)
    self.setTitleColor(textColor ?? .white, for: .normal)
    self.layer.masksToBounds = true
  }
  
  init(text: String, font: UIFont?, textColor: UIColor?, textAlignment: NSTextAlignment?, backgroundColor: UIColor) {
    super.init(frame: .zero)
    
    self.setTitle(text, for: .normal)
    
    self.titleLabel?.font = font ?? AppFont.Regular.font(size: 12)
    self.titleLabel?.textColor = textColor ?? .white
    self.titleLabel?.textAlignment = textAlignment ?? .center
    self.backgroundColor = backgroundColor
    self.layer.masksToBounds = true
  }
  
  init(image: UIImage, tintColor: UIColor) {
    super.init(frame: .zero)
    
    self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    self.tintColor = tintColor
    self.layer.masksToBounds = true
  }
  
  init(image: UIImage, tintColor: UIColor, backgroundColor: UIColor) {
    super.init(frame: .zero)
    
    self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    self.tintColor = tintColor
    self.backgroundColor = backgroundColor
    self.layer.masksToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


