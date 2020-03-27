//
//  Color.swift
//  Vmp
//
//  Created by Anil Joe on 11.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


class Color {
  
  ///White color for dark mode -  Black  color for light mode
  public static var appWhite: UIColor = {
    if #available(iOS 13, *) {
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark { //Dark Mode
          return UIColor.white
        } else {// Light Mode
          return UIColor.black
        }
        
      }
    } else { //iOS 12 and lower.
      return .white
    }
  }()
  
  ///Dark color for dark mode - white color for light mode
  public static var appBackground: UIColor = {
    if #available(iOS 13, *) { //Dark Mode
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          return UIColor.appDarkBackground
        } else {//Light Mode
          return UIColor(red: 234.0 / 255.0, green: 234.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
        }
      }
    } else {
      return .appDarkBackground
    }
  }()
  
  public static var reverseAppBackground: UIColor = {
    if #available(iOS 13, *) { //Dark Mode
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          return UIColor.white
        } else {//Light Mode
          return UIColor.appDarkBackground
        }
      }
    } else {
      return UIColor.white
    }
  }()
  
  
  public static var collectionViewCellBackground: UIColor = {
    if #available(iOS 13, *) { //Dark Mode
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          return UIColor(hexString: "#1A1E30")!
        } else {//Light Mode
          return UIColor.white
        }
      }
    } else {
      return UIColor(hexString: "#1A1E30")!
    }
  }()
  
  public static var appGray: UIColor = {
    if #available(iOS 13, *) { //Dark Mode
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          return .lightGray
        } else {//Light Mode
          return .gray
        }
      }
    } else {
      return .lightGray
    }
  }()
  
  public static var appWhiteBlurryBackground: UIColor = {
    if #available(iOS 13, *) { //Dark Mode
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          return UIColor(white: 1.0, alpha: 0.22)
        } else {//Light Mode
          return .white
        }
      }
    } else {
      return UIColor(white: 1.0, alpha: 0.22)
    }
  }()
  
}



extension UIColor {
  @nonobjc class var appDarkBackground: UIColor {
    return UIColor(hexString: "#222222")!
  }
  
  @nonobjc class var appLightBackground: UIColor {
    return UIColor(hexString: "#FFFFFF")!
  }
  
  @nonobjc class var appBlue: UIColor {
    return UIColor(hexString: "#298FFF")!
  }
  
  @nonobjc class var darkTabBar: UIColor {
    return UIColor(hexString: "#1F1C00")!
  }
  
}
