//
//  MusicPlayerView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 22.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit

class BaseMusicPlayerView: View {
  
  //MARK: - Visual Objects
  
//  let topView = CoursePlayerTopView(frame: .zero)
  
  let blurryImageView = MusicPlayerBlurryBackgroundImageView()
  
  let centerView = MusicPlayerCenterView(frame: .zero)
  
  ///Displays progress and minutes
  let progressView = MusicPlayerProgressView(frame: .zero)
  
//  let bottomView = CoursePlayerBottomView(frame: .zero)

  
  //MARK: - Variables
  var progressViewYOffSet: CGFloat {
    return (screenSize.height/4)
  }
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .black

    loadUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let imageView = UIImageView(image: nil)
  
  //MARK: - UI
  private func loadUI() {
    
    addSubview(blurryImageView)
    blurryImageView.fillToSuperview()
    
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .red
    
    addSubview(imageView)
    imageView.autoSetDimension(.width, toSize: screenSize.width*0.4)
    imageView.autoSetDimension(.height, toSize: screenSize.width*0.4)
    imageView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 65)
//    imageView.anchorCenterYToSuperview(constant: -screenSize.width*0.4)
    imageView.anchorCenterXToSuperview()
    
    
    addSubview(centerView)
    //centerView.anchorCenterYToSuperview(constant: -centerView.selfHeight * 0.1)
    centerView.anchorCenterYToSuperview()
    centerView.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    centerView.autoPinEdge(.right, to: .right, of: self, withOffset: -24)
    centerView.autoSetDimension(.height, toSize: centerView.selfHeight)
    
//    addSubview(bottomView)
//    bottomView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 24)
//    bottomView.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
//    bottomView.autoPinEdge(.right, to: .right, of: self, withOffset: -24)
//    bottomView.autoSetDimension(.height, toSize: bottomView.buttonSize)
    
//    addSubview(topView)
//    topView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 24)
//    topView.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
//    topView.autoPinEdge(.right, to: .right, of: self, withOffset: -24)
//    topView.autoSetDimension(.height, toSize: topView.buttonSize)
    
    addSubview(progressView)
    progressView.anchorCenterYToSuperview(constant: progressViewYOffSet)
    progressView.autoPinEdge(.left, to: .left, of: self, withOffset: 24)
    progressView.autoPinEdge(.right, to: .right, of: self, withOffset: -24)
    progressView.autoSetDimension(.height, toSize: progressView.selfHeight)
  }
}


