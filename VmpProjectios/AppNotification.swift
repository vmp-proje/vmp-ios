//
//  AppNotification.swift
//  VmpProjectios
//
//  Created by Anil Joe on 14.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit


class AppNotification {
  
  
  //MARK: - Singleton
  static let shared = AppNotification()
  init() {}
  
  
  ///Update PlayButton()'s icons automatically
  let musicIndexChangedKey = "musicIndexChangedKey"
  ///Update PlayButton()'s icons automatically
  func musicIndexChanged(content: CategoryContentListData?) {
    NotificationCenter.default.post(name: NSNotification.Name.init(musicIndexChangedKey), object: nil, userInfo: ["content": content])
  }
  
  
  ///Update PlayButton()'s icons automatically
  let updatePlayButtonUIKey = "updatePlayButtonUIKey"
  ///Update PlayButton()'s icons automatically
  func updatePlayButtonUI() {
    NotificationCenter.default.post(name: NSNotification.Name.init(self.updatePlayButtonUIKey), object: nil)
  }
  
  ///Update PlayButton()'s icons by the given PlayStatus value
  let updatePlayButtonUIManuelKey = "updatePlayButtonUIManuelKey"
  ///Update PlayButton()'s icons by the given PlayStatus value
  func updatePlayButtonUIManually(playStatus: PlayStatus) {
    NotificationCenter.default.post(name: NSNotification.Name.init(updatePlayButtonUIManuelKey), object: nil, userInfo: ["playStatus": playStatus])
  }
  
  
  
  
  
  
  /// To present Popup Bar Key on Main Tab Bar
  let presentMusicPopUpBarKey = "presentMusicPopUpBarKey"
  let presentMusicPopUpBarTabBarControllerKey = "presentMusicPopUpBarTabBarControllerKey"
  let presentMusicPopUpViewControllerBarKey = "presentMusicPopUpViewControllerBarKey"
  
  //  let dismissMusicPopUpBarKey = "dismissMusicPopUpBarKey"
  //  func dismissPopupBar() {
  //    NotificationCenter.default.post(name: NSNotification.Name.init(dismissMusicPopUpBarKey), object: nil)
  //  }
  
  func presentPopupBarForTabBarController() {
    NotificationCenter.default.post(name: NSNotification.Name.init(presentMusicPopUpBarTabBarControllerKey), object: nil)
  }
  
  func presentPopupBarForViewController() {
    NotificationCenter.default.post(name: NSNotification.Name.init(presentMusicPopUpViewControllerBarKey), object: nil)
  }
  
}
