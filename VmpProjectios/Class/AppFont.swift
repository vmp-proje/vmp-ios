//
//  Font.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


enum AppFont: String {
  case Light = "HelveticaNeue-Light"
  case Bold = "HelveticaNeue-Bold"
  case Regular = "HelveticaNeue"
  case Medium = "HelveticaNeue-Medium"
  case Kredit = "Kredit"
  
  public func font(size: CGFloat) -> UIFont {
      return UIFont(name: self.rawValue, size: size)!
  }
}
