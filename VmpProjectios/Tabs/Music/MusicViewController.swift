//
//  MusicViewController.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import YoutubeKit

class MusicViewController: ViewController<MusicView>, SearchProtocol,YTSwiftyPlayerDelegate {
  
  
  func playerReady(_ player: YTSwiftyPlayer) {}
  func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {}
  func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState){}
  func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {}
  func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {}
  func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {}
  
  func getYoutubeVideoLink(id: String) -> String {
    //youtube_watch_base_url
    
    return ""
  }
  
  func playVideo(videoId: String) {
  
    showAlert(title: "Make a choice :)", message: nil, buttonTitles: ["Video", "Music"], highlightedButtonIndex: nil) { (index) in
      if index == 0 {
        self.customView.player = YTSwiftyPlayer(
        frame: CGRect(x: 200, y: 200, width: 640, height: 480),
        playerVars: [.videoID(videoId)])
        
        self.customView.player.translatesAutoresizingMaskIntoConstraints = false
        self.customView.showPlayer()
        self.customView.player.delegate = self
        self.customView.player.autoplay = true
        self.customView.player.loadPlayer()
        self.customView.player.playVideo()
      } else {
        
        //TODO: - open MUSIC
      }
    }
  }
  
  
  //MARK: - View Appearance
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.customView.startLoading()
    
    search(text: "Music")
  }
  
  private func search(text: String) {
    YoutubeManager.shared.search(search: text).done { (popularVideos) in
      //         for item in popularVideos.items ?? [] {
      //           print("🔥🔥🔥 title: \(item.snippet?.title) channel name: \(item.snippet?.channelTitle)")
      //         }
      
//      self.customView.setVideos(videos: popularVideos)
      self.customView.videos = popularVideos
      self.customView.musicCollectionView.reloadData()
      self.customView.stopLoading()
    }.catch { (error) in
      self.customView.stopLoading()
      ShowErrorMessage.statusLine(message: "Something went wrong. Please try again.")
    }
  }
  
  
}
