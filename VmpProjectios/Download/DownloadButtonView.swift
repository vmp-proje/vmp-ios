//
//  DownloadButtonView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 15.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

/// Used for Media Player. Shows animation during download process.
class DownloadButtonView: UIView {
  
  //MARK: - Variables
  var shapeLayer: CAShapeLayer?
  
  var state: DownloadState! {
    didSet {
      DispatchQueue.main.async {
        // Set icon
        self.downloadButton.setImage(self.state.getIcon(), for: .normal)
        
        //Set Tint Color
        self.downloadButton.tintColor = self.state == .downloaded ? .statisticGraphicBlue : self.buttonTintColor
      }
    }
  }
  
  
  var buttonTintColor: UIColor = Color.appWhite
  
  //MARK: - Visual Objects
  let downloadButton = Button(image: UIImage(named: "icon-download")!, tintColor: Color.appWhite, backgroundColor: .clear) //Color.collectionViewCellBackground //Color.appBlack.withAlphaComponent(0.6)
  
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = Color.appBlack.withAlphaComponent(0.55)
    
    translatesAutoresizingMaskIntoConstraints = false
    isUserInteractionEnabled = true
    layer.masksToBounds = true
    
    //setupCircleLayers()
    loadUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    cornerRadius = self.width/2
    setupCircleLayers()
  }
  
  
  //MARK: - UI
  private func loadUI() {
    addSubview(downloadButton)
    downloadButton.autoPinEdge(.top, to: .top, of: self, withOffset: 4)
    downloadButton.autoPinEdge(.left, to: .left, of: self, withOffset: 4)
    downloadButton.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -4)
    downloadButton.autoPinEdge(.right, to: .right, of: self, withOffset: -4)
  }
  
  private func setupCircleLayers() {
    let trackLayer = createCircleShapeLayer(strokeColor: .gray, fillColor: .clear)
    layer.addSublayer(trackLayer)
    
    shapeLayer = createCircleShapeLayer(strokeColor: UIColor.statisticGraphicBlue, fillColor: .clear)
    shapeLayer!.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
    shapeLayer!.strokeEnd = 0
    
    layer.addSublayer(shapeLayer!)
  }
  
  private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let circularPath = UIBezierPath(arcCenter: .zero, radius: (frame.width/2), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    layer.path = circularPath.cgPath
    layer.strokeColor = strokeColor.cgColor
    layer.lineWidth = 4
    layer.fillColor = fillColor.cgColor
    layer.lineCap = CAShapeLayerLineCap.square
    let size = frame.width
    layer.position = CGPoint(x: size / 2, y: size / 2)
    
    return layer
  }
  
}
