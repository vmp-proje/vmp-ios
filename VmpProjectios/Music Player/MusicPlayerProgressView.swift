//
//  MusicPlayerProgressView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 22.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation


import UIKit

/// Includes only UISlider  and time labels  (like"03:59")
class MusicPlayerProgressView: UIView {
  
  
  //MARK: - Variables
  var selfHeight: CGFloat {
    return 43
  }
  var labelWidth: CGFloat {
    return (screenSize.width - 48)/2 - 12
  }
  
  
  //MARK: - Visual Objects
  var progressDisplay: UISlider = {
    let timeUpdaterDisplay = UISlider()
    
    let image = UIImage(named: "circle")?.withRenderingMode(.alwaysTemplate).maskWithColor(color: .white)
    let image2 = UIImage(named: "circle_big")?.withRenderingMode(.alwaysTemplate).maskWithColor(color: .white)
    
    timeUpdaterDisplay.isContinuous = true
    
    timeUpdaterDisplay.tintColor = .systemBlue
    timeUpdaterDisplay.maximumTrackTintColor = .gray
    
    timeUpdaterDisplay.setThumbImage(image, for: .normal)
    timeUpdaterDisplay.setThumbImage(image2, for: .highlighted)
    
    timeUpdaterDisplay.translatesAutoresizingMaskIntoConstraints = false
    
    return timeUpdaterDisplay
  }()
  
  ///Label on the left. shows how many seconds passed
  let currentSecondLabel = Label(font: AppFont.Regular.font(size: 14), textColor: Color.appWhite, textAlignment: .left)
  ///Label on the right. shows total duration of the music
  let durationLabel = Label(font: AppFont.Regular.font(size: 14), textColor: Color.appWhite, textAlignment: .right)
  
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    loadUI()
    
    durationLabel.text = "00:00"
    currentSecondLabel.text = "00:00"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateProgress(currentSecond: Double, value: Float) {
    self.currentSecondLabel.text = "\(currentSecond.secondsToCurrentTime())"
    self.progressDisplay.value = value
  }
  
  func resetView() {
    self.currentSecondLabel.text = "00:00"
    self.progressDisplay.value = 0.0
  }
  
  
  //MARK: - UI
  private func loadUI() {
    addSubview(progressDisplay)
    progressDisplay.autoSetDimension(.height, toSize: 10)
    progressDisplay.autoPinEdge(.top, to: .top, of: self)
    progressDisplay.autoPinEdge(.left, to: .left, of: self)
    progressDisplay.autoPinEdge(.right, to: .right, of: self)
    
    addSubview(currentSecondLabel)
    currentSecondLabel.autoPinEdge(.top, to: .bottom, of: progressDisplay, withOffset: 12)
    currentSecondLabel.autoPinEdge(.left, to: .left, of: self)
    currentSecondLabel.autoSetDimension(.width, toSize: labelWidth)
    
    addSubview(durationLabel)
    durationLabel.autoPinEdge(.top, to: .bottom, of: progressDisplay, withOffset: 12)
    durationLabel.autoPinEdge(.right, to: .right, of: self)
    durationLabel.autoSetDimension(.width, toSize: labelWidth)
  }
}


extension UIImage {
  func maskWithColor(color: UIColor) -> UIImage? {
    let maskImage = cgImage!
    
    let width = size.width
    let height = size.height
    let bounds = CGRect(x: 0, y: 0, width: width, height: height)
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
    
    context.clip(to: bounds, mask: maskImage)
    context.setFillColor(color.cgColor)
    context.fill(bounds)
    
    if let cgImage = context.makeImage() {
      let coloredImage = UIImage(cgImage: cgImage)
      return coloredImage
    } else {
      return nil
    }
  }
  
}

extension Double {
  func secondsToCurrentTime() -> String {
    //Worst Case check
    if self.isInfinite || self.isNaN{
      return "00:00"
    }
    
    if self>=3600 {
      let hour = Int(Int(self) / 3600)
      let minutes = (Int(self)-(hour*3600))/60
      let seconds = Int(Int(self) % 60)
      return NSString(format:"%02d:%02d:%02d", hour, minutes, seconds) as String
    }
    
    let minutes = Int(self / 60)
    let seconds = Int(Int(self) % 60)
    return NSString(format:"%02d:%02d", minutes, seconds) as String
  }
}
