//
//  GlobalSearchViewController.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit
import YoutubeKit


protocol SearchProtocol {
  func playVideo(videoId: String)
}


class GlobalSearchViewController: ViewController<GlobalSearchView>, UISearchBarDelegate, YTSwiftyPlayerDelegate, SearchProtocol {
  
  
  func playerReady(_ player: YTSwiftyPlayer) {}
  func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {}
  func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState){}
  func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {}
  func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {}
  func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {}
  
  
  
  //MARK: - Variables
  var sentRequestCount = 0
  
  var doneRequestCount = 0
  
  var timer: BenchTimer!
  
  
  
  //MARK: - Visual Objects
  let searchField: UISearchBar = {
    let bar = UISearchBar()
    bar.translatesAutoresizingMaskIntoConstraints = false
    bar.placeholder = "Search".localized()
    bar.searchBarStyle = .minimal
    bar.tintColor = UIColor.systemBackground
    bar.barTintColor = .white
    bar.backgroundColor = .clear
    //    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: appWhite]
    
    return bar
  }()
  
  
  func playVideo(videoId: String) {
    customView.player = YTSwiftyPlayer(
    frame: CGRect(x: 200, y: 200, width: 640, height: 480),
    playerVars: [.videoID(videoId)])
    
    customView.player.translatesAutoresizingMaskIntoConstraints = false
    customView.showPlayer()
    customView.player.delegate = self
    customView.player.autoplay = true
    customView.player.loadPlayer()
    customView.player.playVideo()
  }
  
  //MARK: - View Appearence
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customView.delegate = self
           
    
    //    customView.delegate = self
    setupNavigationBar()
    
    searchField.becomeFirstResponder()
    
    let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    dismissTapGesture.cancelsTouchesInView = false
    customView.addGestureRecognizer(dismissTapGesture)
  }
  
  private func setupNavigationBar() {
    let closeButton = UIButton()
    closeButton.setImage(UIImage(named: "close_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
    closeButton.tintColor = Color.appWhite
    closeButton.imageView?.contentMode = .scaleAspectFill
    closeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 0)
    
    closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    let cancelBarButton = UIBarButtonItem(customView: closeButton)
    navigationItem.rightBarButtonItem = cancelBarButton
    
    searchField.delegate = self
    searchField.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 25)
    navigationItem.titleView = searchField
    
    navigationController?.navigationBar.barTintColor = UIColor.systemBackground
    navigationController?.navigationBar.isTranslucent = false
    //Remove borders
    DispatchQueue.main.async {
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      self.navigationController?.navigationBar.shadowImage = UIImage()
      self.navigationController?.navigationBar.layoutIfNeeded()
    }
  }
  
  
  func searchBar(_: UISearchBar, textDidChange _: String) {
    if searchField.text != "", searchField.text != nil {
      stopSearchTimer(text: searchField.text!)
      runTimer(text: searchField.text!)
    } else {
      customView.videos = nil
      customView.collectionView.reloadData()
    }
  }
  
  
  private func runTimer(text: String) {
    timer = BenchTimer()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.61) {
      self.stopSearchTimer(text: text)
    }
  }
  
  private func stopSearchTimer(text _: String) {
    DispatchQueue.main.async {
      if self.searchField.text != "" {
        guard let timer = self.timer else { return }
        let result = timer.stop()
        if result > 0.55 { //Can fetch data
          self.customView.startLoading()
          self.sentRequestCount += 1
          //
          
          print("🪀send request")
          self.customView.startLoading()
          
          YoutubeManager.shared.search(search: self.searchField.text ?? "").done { (popularVideos) in
            
            for item in popularVideos.items ?? [] {
              print("🔥🔥🔥 title: \(item.snippet?.title) channel name: \(item.snippet?.channelTitle)")
            }
            
            self.customView.setVideos(videos: popularVideos)
            
            print("🪀🪀🪀🪀🪀 sa: \(popularVideos)")
            
//            self.stopLoadingAnimation()
            self.customView.stopLoading()
          }.catch { (error) in
//            self.stopLoadingAnimation()
            self.customView.stopLoading()
          }
        }
      }
    }
  }
  
  @objc func dismissVC() {
    dismiss(animated: true, completion: nil)
  }
  
  //  @objc func dismissKeyboard() {
  //    customView.endEditing(true)
  //  }
  
  override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
    view.endEditing(true)
  }
  
}






class BenchTimer {
  let startTime: CFAbsoluteTime
  var endTime: CFAbsoluteTime?
  
  init() {
    startTime = CFAbsoluteTimeGetCurrent()
  }
  
  func stop() -> CFAbsoluteTime {
    endTime = CFAbsoluteTimeGetCurrent()
    
    return duration!
  }
  
  var duration: CFAbsoluteTime? {
    if let endTime = endTime {
      return endTime - startTime
    } else {
      return nil
    }
  }
}
