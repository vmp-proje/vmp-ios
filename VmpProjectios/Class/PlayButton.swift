//
//  PlayButton.swift
//  VmpProjectios
//
//  Created by Anil Joe on 3.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit



///Created for Play Button
enum PlayStatus {
  case paused
  case playing
 
  func getIcon() -> UIImage {
    switch self {
    case .paused:
      return UIImage(named: "player-play-small")!.withRenderingMode(.alwaysTemplate)
    default:
      return UIImage(named: "pause-small")!.withRenderingMode(.alwaysTemplate)
    }
  }
  
}


class PlayButton: Button {
  
  var locked: Bool = false {
    didSet {
      if locked == true {
        setImage(UIImage(named: "lock")!.withRenderingMode(.alwaysTemplate), for: .normal)
//        self.isUserInteractionEnabled = false
      } else {
        setImage(UIImage(named: "player-play-small")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        self.isUserInteractionEnabled = true
      }
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      if self.isHighlighted {
        showShadow()
      } else {
        layer.shadowColor = UIColor.clear.cgColor
      }
    }
  }
  
  var playStatus: PlayStatus = .paused
  
  /// Updates Button's image
  func paused() {
    if !locked {
      playStatus = .paused
      self.setImage(PlayStatus.paused.getIcon(), for: .normal)
    }
  }
  
  /// Updates Button's image
  func playing() {
    if !locked {
      playStatus = .playing
      self.setImage(PlayStatus.playing.getIcon(), for: .normal)
    }
  }
  
  
  
  //MARK: - Initialization
  init() {
    super.init(frame: .zero)
    self.backgroundColor = Color.collectionViewCellBackground.withAlphaComponent(0.55)
    self.setImage(UIImage(named: "player-play-small")?.withRenderingMode(.alwaysTemplate), for: .normal)
    self.tintColor = Color.appWhite
    self.layer.masksToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.width / 2
  }
  
  func showShadow() {
    layer.shadowColor = Color.appWhite.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    layer.masksToBounds = false
    layer.shadowRadius = 1.0
    layer.shadowOpacity = 0.5
    layer.cornerRadius = frame.width / 2
  }
  
}
