//
//  MusicPlayerViewController.swift
//  VmpProjectios
//
//  Created by Anil Joe on 3.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
//import LNPopupController
import BottomPopup


protocol CloseMusicPlayerPopupProtocol {
  func dismissMusicPlayerPopupWithDuration(duration: CGFloat)
  func dismissMusicPlayerPopup()
  func closeMusicPlayerPopup()
}



class MusicPlayerViewController: BaseMusicPlayerViewController<BaseMusicPlayerView>, BottomPopupDelegate {
  
  
  //MARK: - Constants
  static var shared = MusicPlayerViewController()
  
  
 //MARK: - DownloadButtonProtocol
//  override func updateButton(state: DownloadState, percentage: CGFloat, url: URL?) {
//    DispatchQueue.main.async {
//      self.downloadState = state
//      if self.currentMediaURL == url {
//        self.customView.bottomView.downloadButton.state = state
//        self.customView.bottomView.downloadButton.shapeLayer.strokeEnd = percentage
//
//      } else { //We are looking for a different content
//        if let url = self.getAPIUrl(link: self.currentMedia?.attributes?.media) { //
//          let state = MusicDownloadManager.shared.getDownloadState(content: self.currentMedia!, apiUrl: url)
//          self.customView.bottomView.downloadButton.state = self.downloadState
//          self.customView.bottomView.downloadButton.shapeLayer.strokeEnd = state.getPercentage()
//        } else {
//          self.customView.bottomView.downloadButton.state = .startDownload
//          self.customView.bottomView.downloadButton.shapeLayer.strokeEnd = 0.0
//        }
//      }
//    }
//  }
  
  
  //MARK: - Variables
  override var className: String {
    get {
      return "MusicPlayerViewController"
    }
    set {
      super.className = newValue
    }
  }
  
  
  //MARK: - Bookmark Button
  override func updateBookmarkButton(exists: Bool) {
    let color: UIColor = exists ? .statisticGraphicBlue : Color.appWhite
//    customView.bottomView.bookmarkButton.tintColor = color
  }
  
  
  //MARK: - View Appereance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    //navigationController?.popupBar.isHidden = true
    navigationController?.dismissPopupBar(animated: true, completion: nil)
    
//    self.customView.collectionView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Add Targets
//    customView.topView.closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
//    customView.bottomView.downloadButton.downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
  }
  
 
  @objc func dismissVC() {
    dismissMusicPlayerVCDelegateForViewController?.closeMusicPlayerPopup()
    dismissMusicPlayerVCDelegateForMainTabBar?.closeMusicPlayerPopup()
  }
  
}

