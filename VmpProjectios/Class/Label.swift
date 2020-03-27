//
//  Label.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


class Label: UILabel {
  
  
  init(text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int?) {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.numberOfLines = numberOfLines ?? 0
  }
  
  
  init(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int?) {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.numberOfLines = numberOfLines ?? 0
  }
  
  
  init(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
  }
  
  init(text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    adjustsFontSizeToFitWidth = false
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
