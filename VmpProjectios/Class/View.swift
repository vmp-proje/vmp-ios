//
//  View.swift
//  Vmp
//
//  Created by Metin Yıldız on 10.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import TPKeyboardAvoiding
import NVActivityIndicatorView
import PureLayout
import SwifterSwift

class View: UIView {
  
  
  //MARK: - Visual Objects
  var loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: UIColor.white, padding: nil)
  let blackBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  /// Used to cover bottom view when mini music player popup presented in  ViewController<V: View> classes
  let safeAreaBottomViewForMusicPlayer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(named: "#25292C")
    
    return view
  }()
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.systemBackground
    setViews()
    layoutViews()
    setupLoadingView()
  }
  
  /// Created to prevent switching tabs while fetchiung data
  private func setupLoadingView() {
    addSubview(blackBackgroundView)
    blackBackgroundView.fillToSuperview()
    blackBackgroundView.isHidden = true
    
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(loadingIndicator)
    loadingIndicator.anchorCenterXToSuperview()
    loadingIndicator.anchorCenterYToSuperview(constant: -5)
    loadingIndicator.autoSetDimension(.width, toSize: 60)
    loadingIndicator.autoSetDimension(.height, toSize: 60)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setViews()
    layoutViews()
    
  }
  
  //MARK: - Loading Animations
  func startLoading() {
    blackBackgroundView.isHidden = false
    loadingIndicator.startAnimating()
  }
  
  func stopLoading() {
    blackBackgroundView.isHidden = true
    loadingIndicator.stopAnimating()
  }
  
  
  
  //MARK: - UI
  //// Set your view and its subviews here.
  func setViews() {}
  /// Layout your subviews here.
  func layoutViews() {}
  
  internal func showBottomViewForMusicPlayer() {
    if #available(iOS 11.0, *) {
      let window = UIApplication.shared.keyWindow
      if let bottomPadding = window?.safeAreaInsets.bottom {
        addSubview(safeAreaBottomViewForMusicPlayer)
        
        safeAreaBottomViewForMusicPlayer.autoPinEdge(.bottom, to: .bottom, of: self)
        safeAreaBottomViewForMusicPlayer.autoPinEdge(.left, to: .left, of: self)
        safeAreaBottomViewForMusicPlayer.autoPinEdge(.right, to: .right, of: self)
        safeAreaBottomViewForMusicPlayer.autoSetDimension(.height, toSize: bottomPadding+26)
        
        safeAreaBottomViewForMusicPlayer.isHidden = false
        bringSubviewToFront(safeAreaBottomViewForMusicPlayer)
      }
    }
  }
  
}
