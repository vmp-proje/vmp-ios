//
//  MusicPlayerViewController.swift
//  VmpProjectios
//
//  Created by Anil Joe on 22.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//


import UIKit
import NVActivityIndicatorView
import AVFoundation
import MediaPlayer
import LNPopupController
import Alamofire


//MARK: - Protocol
protocol DownloadButtonProtocol {
  func updateButton(state: DownloadState, percentage: CGFloat, url: URL?)
  func updateButton(state: DownloadState)
}


protocol MusicPlayerCommunicationProtocol {
  func readyToPlay()
  func finishedPlaying()
}


//MARK: - BaseMusicPlayerViewController
///Created to implement MVC's ViewController<V:> View Protocol
class BaseMusicPlayerViewController<V: BaseMusicPlayerView>: LNPopupCustomBarViewController, NVActivityIndicatorViewable, DownloadButtonProtocol, MusicPlayerCommunicationProtocol {
  func finishedPlaying() {
  }
  
  
  
//  static var shared = MusicPlayerViewController()
  
  //MARK: - MusicPlayerCommunicationProtocol

  
  func readyToPlay() {
    //Set duration
    let duration = self.audioPlayer.player.currentItem?.asset.duration.seconds ?? 0.0
    customView.progressView.durationLabel.text = "\(duration.secondsToCurrentTime())"
    self.updateProgressViewUI()
    AudioPlayer.shared.setupNowPlaying()
  }
  
//  func finishedPlaying() {
//    self.resetMusicPlayerUI()
//
//    guard  let currentTrack = audioPlayer.currentTrack else {return}
//
//    if audioPlayer.section_type != "music" && audioPlayer.section_type != "ambiance" {
//      //Show Experience Screen
//      self.showMusicExperienceViewController(content: currentTrack)
//    }
//
//    ContentManager.shared.addProgressToContent(completed: true)
//  }
  
  private func resetMusicPlayerUI() {
    if self.progressBarTimer != nil {
      self.progressBarTimer!.invalidate()
      self.progressBarTimer = nil
    }
    
    self.customView.progressView.currentSecondLabel.text = "00:00"
    self.customView.progressView.progressDisplay.value = 0.0
  }
  
//  func musicIndexChanged(content: CategoryContentListData) {
  @objc func musicIndexChanged(notification: Notification) {
    guard let content = notification.userInfo?["content"] as? CategoryContentListData else {return}
    guard let attribute = content.attributes else {return}
    print("\n\n musicIndexChanged()  😎😎😎😎😎 new song: \(attribute.title)")
    
    customView.centerView.playButton.contentId = content.attributes?.id
    
    self.resetMusicPlayerUI()
    self.updatePopupBar(info: attribute)
    self.customView.blurryImageView.backgroundImageView.image = nil
    self.customView.centerView.titleLabel.text = content.attributes?.title ?? ""
//    self.customView.progressView.durationLabel.text = attribute.duration?.double.secondsToCurrentTime()
    
//    self.updateProgressViewUI()
    
//     Updates download button with delegate
    //FIXME: - add this later
    if let url = content.attributes?.url?.url {
      let state = MusicDownloadManager.shared.getDownloadState(content: content, apiUrl: url)
      print("okok state: \(state)")
      self.updateButton(state: state, percentage: -1.0, url: nil) //Update DownloadButton's UI
      self.customView.setNeedsDisplay()
    }
  }
  
  
  //MARK: - DownloadButtonProtocol
  func updateButton(state: DownloadState) {}
  func updateButton(state: DownloadState, percentage: CGFloat, url: URL?) {}
  
  
  //MARK: - Constants
  var className = "BaseMusicPlayerViewController.swift"
  var sectionType: String! = "course" //FIXME: - course'u daha sonra bosa al.
  
  
  //MARK: - Variables
  
  /// Updates label and slider
  var progressBarTimer: Timer!
  
  var downloadState: DownloadState = .startDownload
  var currentMedia: CategoryContentListData? {
//    return nil
    return audioPlayer.trackArr[audioPlayer.currentIndex]
  }
  
  
  //MARK: - Visual Objects
  let popupBarPlayButton = UIBarButtonItem(image: UIImage(named: "player-play-small")!, style: .done, target: self, action: #selector(playButtonTapped))
  
  
  //MARK: - View Appereance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNeedsStatusBarAppearanceUpdate()
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    updatePlayButtons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //Set Delegates
    MusicDownloadManager.shared.downloadDelegate = self
    
    //    if let track = audioPlayer.currentTrack?.attributes {
    //      self.updatePopupBar(info: track)
    //    }
//    updatePlayButtons()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    AudioPlayer.shared.delegate = self
    
    NotificationCenter.default.setObserver(self, selector: #selector(musicIndexChanged(notification:)), name: NSNotification.Name.init(AppNotification.shared.musicIndexChangedKey), object: nil)
    
    //Set Delegates
    MusicDownloadManager.shared.downloadDelegate = self
    
    //Setup PopupBar
    popupBar.marqueeScrollEnabled = true
    popupBarPlayButton.addTargetForAction(self, action: #selector(playButtonTapped))
    popupBarPlayButton.tintColor = .white
    popupItem.rightBarButtonItems = [popupBarPlayButton]
    popupBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Color.appWhite, NSAttributedString.Key.font : AppFont.Bold.font(size: 15)] //TODO: fix font

    
    LNPopupBar.appearance().barTintColor = UIColor(hexString: "#26292C") //TODO: light/dark
    self.popupContentView.popupCloseButtonStyle = .round
    
    // Add Targets
    customView.centerView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    customView.bottomView.downloadButton.downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
//    customView.centerView.prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
//    customView.centerView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    customView.progressView.progressDisplay.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    
    
    // Set Listeeners
//    NotificationCenter.default.addObserver(self, selector: #selector(updatePlayButtons), name: NSNotification.Name.init(AppNotification.shared.updateMusicPlayerPlayButtonsKey), object: nil)
  }
  
  
  var audioPlayer: AudioPlayer {
    return AudioPlayer.shared
    
  }
  //MARK: - Button Actions
  @objc func playButtonTapped() {
    if audioPlayer.finishedPlayingPlaylist == true {
      audioPlayer.playCurrentTrack()
    } else {
      if audioPlayer.isPlaying() == true { //Playing ATM
        audioPlayer.pause()
      } else {
        audioPlayer.resume()
      }
//      updatePlayButtons()
    }
  }
  
  
  @objc func nextButtonTapped() {
    audioPlayer.nextTrack()
  }
  
  @objc func prevButtonTapped() {
    audioPlayer.previousTrack()
  }
  
  
  
  
  @objc func showUpgradeView() {
//    let upgradeVC = SubscriptionViewController()
//    upgradeVC.modalPresentationStyle = .overCurrentContext
//    present(upgradeVC, animated: true, completion: nil)
  }
  
  var currentMediaURL: URL? {
    return audioPlayer.currentTrackURL.url
//    return nil
//    return getAPIUrl(link: self.currentMedia?.attributes?.media
  }
  
  @objc func downloadButtonTapped() {
//    func downloadButtonTapped() {
    //Check if user is Premium
//    if UserManager.shared.currentUser()?.is_premium == false {
//      showUpgradeView()
//      return
//  }
      
    guard let currentMedia = self.currentMedia,
      let mediaUrl = self.currentMediaURL
      else {return}

    let localURL = MusicDownloadManager.shared.getLocalURL(url: mediaUrl, id: currentMedia.attributes!.id!)
    if MusicDownloadManager.shared.hasDownloaded(url: localURL) {
      self.showAlert(title: "Remove from Downloads?".localized(), message: "You won't be able to play this offline.".localized(), buttonTitles: ["Cancel".localized(), "Remove".localized()], highlightedButtonIndex: 0) { (index) in
        if index == 1 { // Remove song
          MusicDownloadManager.shared.removeFile(localURL: localURL, updatePlaylistCollectionView: true)
        }
      }
    } else if self.downloadState == .downloading { //Cancel current download.
      MusicDownloadManager.shared.cancelDownload(url: mediaUrl)
    } else {
      MusicDownloadManager.shared.prepare(queue: [currentMedia])
    }
  }
  
 
  
  //MARK: - Music Player Functions
  @objc func sliderValueChanged(_ slider: UISlider) {
    let duration = self.audioPlayer.player.currentItem?.duration.seconds ?? 0.0
    if duration.isNaN || duration.isInfinite {
      return
    }

    let newCurrentTime: Int64 = Int64(duration * Double(slider.value))
    audioPlayer.player.seek(to: CMTimeMake(value: newCurrentTime, timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
//      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = MusicPlayer.shared.playerItem?.currentTime().seconds
  }
  
  
  //MARK: - UI Updaters
  /// Updates Popup Bar's information
  func updatePopupBar(info: CategoryContentListAttributes) {
    self.popupItem.title = info.title ?? ""
    
    //Download image
    DispatchQueue.global().async {
      if let url = info.thumbnail?.url {
        Alamofire.request(url).responseData { (response) in
          if response.error == nil {
            if let data = response.data {
              DispatchQueue.main.async {
                self.popupItem.image = UIImage(data: data) //mini music player
                self.customView.blurryImageView.backgroundImageView.image = UIImage(data: data)
                self.customView.imageView.image = UIImage(data: data)
              }
            }
          }
        }
      }
    }
  }
  
//  func updatePlayButton(isPlaying: Bool) {
//    //    DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
//    if !isPlaying { // Not Playing
//      self.customView.centerView.playButton.setImage(UIImage(named: "player-play")?.withRenderingMode(.alwaysTemplate), for: .normal)
//      self.popupBarPlayButton.image = UIImage(named: "player-play-small")!.withRenderingMode(.alwaysTemplate)
//    } else { // Playing ATM
//      print("playing atm")
//      self.customView.centerView.playButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate), for: .normal)
//      self.popupBarPlayButton.image = UIImage(named: "pause-small")!.withRenderingMode(.alwaysTemplate)
//    }
//
//    //Update MainTabBar's popupBarPlayButton
////    AppNotification.shared.updateTabBarPlayButton()
//  }
  
  ///Checks Automatically
//  @objc func updatePlayButtons() {
//    if self.audioPlayer.isPlaying() == false {
//      self.customView.centerView.playButton.setImage(UIImage(named: "player-play")?.withRenderingMode(.alwaysTemplate), for: .normal)
//      self.popupBarPlayButton.image = UIImage(named: "player-play-small")!.withRenderingMode(.alwaysTemplate)
//    } else {
//      self.customView.centerView.playButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate), for: .normal)
//      self.popupBarPlayButton.image = UIImage(named: "pause-small")!.withRenderingMode(.alwaysTemplate)
//    }
//
//    //Update MainTabBar's popupBarPlayButton
//    AppNotification.shared.updateTabBarPlayButton()
//  }
  
  /// Starts Timer
  func updateProgressViewUI() {
    if self.progressBarTimer == nil {
      self.progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
  }
  
  
   @objc func timerAction() {
     let duration = self.audioPlayer.player.currentItem?.duration.seconds ?? 0.0
     let currentTime = self.audioPlayer.player.currentTime().seconds ?? 0.0
     
     // Update Slider
     let time = Float(currentTime / duration)
     self.customView.progressView.updateProgress(currentSecond: currentTime, value: time)
   }
  
  func updateBookmarkButton(exists: Bool) {}
  
  func startLoadingAnimation() {
    self.startAnimating(CGSize(width: 70, height: 70), message: nil, messageFont: nil, type: .circleStrokeSpin, color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil, fadeInAnimation: nil)
  }
  
  
  override func loadView() {
    view = V()
  }
  
  var customView: V {
    return view as! V
  }
}


extension AVPlayer {
  var isPlaying: Bool {
    return rate != 0 && error == nil
  }
}



extension NotificationCenter {
  func setObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
    NotificationCenter.default.removeObserver(observer, name: name, object: object)
    NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
  }
}
