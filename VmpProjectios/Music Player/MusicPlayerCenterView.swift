//
//  MusicPlayerCenterView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 22.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit


class MusicPlayerCenterView: UIView {
  
  
  //MARK: - Variables
  ///Returns screenSize.height/2.5
  var selfHeight: CGFloat {
    return screenSize.height/2.8
  }
  
  var playButtonHeight: CGFloat {
    return selfHeight * 0.25
  }
  
  
  //MARK: - Visual Objects
  let contentTypeLabel = Label(font: AppFont.Regular.font(size: 14), textColor: Color.appWhite, textAlignment: .center)
//  let titleLabel = TTTAttributedLabel(frame: .zero)
  let titleLabel = Label(font: AppFont.Bold.font(size: 25), textColor: Color.appWhite, textAlignment: .center)
  
  let playButton = Button(image: UIImage(named: "player-play")!, tintColor: Color.appWhite, backgroundColor: Color.appBlack.withAlphaComponent(0.55))
//  let prevButton = Button(image: UIImage(named: "backward2")!, tintColor: Color.appWhite, backgroundColor: .clear)
//  let nextButton = Button(image: UIImage(named: "forward2")!, tintColor: Color.appWhite, backgroundColor: .clear)
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    loadUI()
    
    titleLabel.numberOfLines = 2
//    titleLabel.font = AppFont.Bold.font(size: 25)
//    titleLabel.textColor = Color.appWhite
//    titleLabel.verticalAlignment = .top
//    titleLabel.textAlignment = .center
//    titleLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - UI
  private func loadUI() {
    addSubview(contentTypeLabel)
    addSubview(titleLabel)
    addSubview(playButton)
//    addSubview(nextButton)
//    addSubview(prevButton)
    
    contentTypeLabel.autoPinEdge(.top, to: .top, of: self)
    contentTypeLabel.autoPinEdge(.left, to: .left, of: self)
    contentTypeLabel.autoPinEdge(.right, to: .right, of: self)
    contentTypeLabel.autoSetDimension(.height, toSize: 22)
    contentTypeLabel.numberOfLines = 1
    
    titleLabel.autoPinEdge(.top, to: .bottom, of: contentTypeLabel, withOffset: 8)
    titleLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 20)
    titleLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -20)
    titleLabel.autoPinEdge(.bottom, to: .top, of: self.playButton, withOffset: -24)

    playButton.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
    playButton.anchorCenterXToSuperview()
    playButton.autoSetDimension(.width, toSize: playButtonHeight+10)
    playButton.autoSetDimension(.height, toSize: playButtonHeight+10)
    playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
//    nextButton.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -5)
//    nextButton.autoPinEdge(.left, to: .right, of: playButton, withOffset: 20)
//    nextButton.autoSetDimension(.width, toSize: playButtonHeight)
//    nextButton.autoSetDimension(.height, toSize: playButtonHeight)
//    nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    
//    prevButton.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -5)
//    prevButton.autoPinEdge(.right, to: .left, of: playButton, withOffset: -20)
//    prevButton.autoSetDimension(.width, toSize: playButtonHeight)
//    prevButton.autoSetDimension(.height, toSize: playButtonHeight)
//    prevButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
  }
  
}
