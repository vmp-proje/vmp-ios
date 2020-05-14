//
//  PlayButton.swift
//  VmpProjectios
//
//  Created by Anil Joe on 14.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit
import Lottie



//MARK: - PlayStatus
///Created for Play Button
enum PlayStatus {
  case paused
  case playing
  case loading
  
  func getIcon() -> UIImage? {
    switch self {
    case .paused:
      return UIImage(named: "player-play-small")!.withRenderingMode(.alwaysTemplate)
    case .playing:
      return UIImage(named: "pause-small")!.withRenderingMode(.alwaysTemplate)
    default:
      return nil
      //return UIImage(named: "pause-small")!.withRenderingMode(.alwaysTemplate)
    }
  }
}




//MARK: - PlayButton
class PlayButton: Button {
  
  
  //MARK: - Visual Objects
  let loadingAnimation: AnimationView = {
    let view = AnimationView(name: "downloading_animation")
    view.loopMode = .loop
    return view
  }()
  
  
  
  //MARK: - Variables
  var contentId: String?
  
  var locked: Bool = false {
    didSet {
      DispatchQueue.main.async {
        if self.locked == true {
          self.setImage(UIImage(named: "lock")!.withRenderingMode(.alwaysTemplate), for: .normal)
          //        self.isUserInteractionEnabled = false
        } else {
          self.setImage(UIImage(named: "player-play-small")?.withRenderingMode(.alwaysTemplate), for: .normal)
          //        self.isUserInteractionEnabled = true
        }
      }
    }
  }
  
  ///Update UI automaticaly.
  @objc func updateButtonUI() {
    if !locked {
      DispatchQueue.main.async {
        if AudioPlayer.shared.currentTrack?.id == self.contentId {
          if AudioPlayer.shared.isLoading == true {
            self.isUserInteractionEnabled = false
            self.playStatus = .loading
            
          } else if AudioPlayer.shared.isPlaying() {
            self.isUserInteractionEnabled = true //this should work first
            self.playStatus = .playing
            
          } else {
            self.isUserInteractionEnabled = false
            self.playStatus = .paused
            
          }
          
        } else {
          self.isUserInteractionEnabled = false
          self.playStatus = .paused
        }
      }
    }
  }
  
  ///Update UI by the given PlayStatus value
  @objc func updateUI(notification: Notification) {
    DispatchQueue.main.async {
      if !self.locked {
        if let playStatus = notification.userInfo?["playStatus"] as? PlayStatus {
          if AudioPlayer.shared.currentTrack?.id == self.contentId {
            self.playStatus = playStatus
            if playStatus == .playing {
              self.isUserInteractionEnabled = true
            }
          } else {
            self.isUserInteractionEnabled = false
            self.playStatus = .paused
          }
        }
      }
    }
  }
  
  
  //MARK: Loading Animation
  func startLoadingAnimation() {
    DispatchQueue.main.async {
      //      self.imageView?.isHidden = true
      self.loadingAnimation.isHidden = false
      self.loadingAnimation.play()
    }
  }
  
  internal func stoploadingAnimation() {
    DispatchQueue.main.async {
      //      self.imageView?.isHidden = false
      self.loadingAnimation.isHidden = true
      self.loadingAnimation.stop()
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
  
  var playStatus: PlayStatus = .paused {
    didSet {
      if !locked {
        DispatchQueue.main.async {
          self.setImage(self.playStatus.getIcon(), for: .normal)
        }
        
        if playStatus == .loading {
          startLoadingAnimation()
        } else {
          stoploadingAnimation()
        }
      }
    }
  }
  
  
  //MARK: - Initialization
  init() {
    super.init(frame: .zero)
    
    self.backgroundColor = Color.collectionViewCellBackground.withAlphaComponent(0.55)
    self.setImage(UIImage(named: "player-play-small")?.withRenderingMode(.alwaysTemplate), for: .normal)
    self.tintColor = Color.appWhite
    self.layer.masksToBounds = true
    
    self.loadingAnimation.isHidden = true
    addSubview(loadingAnimation)
    loadingAnimation.anchorCenterYToSuperview()
    loadingAnimation.anchorCenterXToSuperview()
    loadingAnimation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.67).isActive = true
    loadingAnimation.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.67).isActive = true
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateUI(notification:)), name: NSNotification.Name.init(AppNotification.shared.updatePlayButtonUIManuelKey), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateButtonUI), name: NSNotification.Name.init(AppNotification.shared.updatePlayButtonUIKey), object: nil)
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
    layer.shadowColor = Color.reverseAppBackground.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    layer.masksToBounds = false
    layer.shadowRadius = 10.0
    layer.shadowOpacity = 0.4
    layer.cornerRadius = frame.width / 2
  }
  
}







//MARK: - PopupBarPlayButton
internal class PopupInnerPlayButton: PlayButton {
  
  
  ///Overriding because; this button always be user interaction enabled
  override var playStatus: PlayStatus {
    didSet {
      DispatchQueue.main.async {
        self.setImage(self.playStatus.getIcon(), for: .normal)
        self.isUserInteractionEnabled = true //always have to interaction enabled.
      }
      
      if playStatus == .loading {
        startLoadingAnimation()
      } else {
        stoploadingAnimation()
      }
    }
  }
  
  override init() {
    super.init()
    
    self.backgroundColor = .clear
    self.tintColor = .white
    self.isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PopupBarPlayButton: UIView {
  
  //let playButton = MusicPlayerPlayButton()
  let playButton = PopupInnerPlayButton()
  var contentId: String? {
    didSet {
      playButton.contentId = self.contentId
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadUI()
    //    self.translatesAutoresizingMaskIntoConstraints = false
    //    playButton.translatesAutoresizingMaskIntoConstraints = false
    //    playButton.tintColor = .black
    
    //    playButton.isUserInteractionEnabled = true
    isUserInteractionEnabled = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func loadUI() {
    addSubview(playButton)
    playButton.anchorCenterYToSuperview()
    playButton.autoSetDimension(.height, toSize: 46)
    playButton.autoSetDimension(.width, toSize: 46)
    playButton.autoPinEdge(.right, to: .right, of: self, withOffset: -5)
  }
}
