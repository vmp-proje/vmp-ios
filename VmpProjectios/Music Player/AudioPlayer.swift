//
//  AudioPlayer.swift
//  VmpProjectios
//
//  Created by Anil Joe on 14.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Signals
import MediaPlayer




//MARK: - AudioPlayer
class AudioPlayer: NSObject {
  
  
  //MARK: - Variables
  static let shared = AudioPlayer()
//  var cellUIDelegate: CellUIProtocol?
  
  var delegate: MusicPlayerCommunicationProtocol?
  var currentIndex = 0
//  var authors: [Included] = []
  
  var currentTime: Double? {
    if player.currentTime().seconds != .nan && player.currentTime().seconds != .infinity {
      return player.currentTime().seconds
    } else {
      return nil
    }
  }

  
  public var audioPlayerConfig:Dictionary<String,Any> = [
    "loop": false,
    "volume": 1.0
  ]
  
  //  private var playerViewControllerKVOContext = 0
  var observersActivated: Bool = false
  
  var audioQueueObserver: NSKeyValueObservation?
  var audioQueueStatusObserver: NSKeyValueObservation?
  var audioQueueBufferEmptyObserver: NSKeyValueObservation?
  var audioQueueBufferAlmostThereObserver: NSKeyValueObservation?
  var audioQueueBufferFullObserver: NSKeyValueObservation?
  var audioQueueStallObserver: NSKeyValueObservation?
  var audioQueueWaitingObserver: NSKeyValueObservation?
  var assetPoolObserver: NSKeyValueObservation?
  
  var playbackLikelyToKeepUpKeyPathObserver: NSKeyValueObservation?
  var playbackBufferEmptyObserver: NSKeyValueObservation?
  var playbackBufferFullObserver: NSKeyValueObservation?
  
  var audioItem: AVPlayerItem!
  let onError = Signal<(message:String, error:Error)>()
  let onCollectionReady = Signal<Bool>()
  
  /// SAMPLE LIST
  var autoPlayAfterFetch = false
  
  var trackArr: Array<CategoryContentListData> = []
  
  var currentTrack: CategoryContentListData? {
    if trackArr.count > currentIndex {
      return self.trackArr[currentIndex]
    }
    return nil
  }
  
  
  
  var currentTrackURL: String {
    return self.currentTrack?.attributes?.url ?? ""
//    let link = self.trackArr[currentIndex].attributes?.media
//    if getAPIUrl(link: link) != nil {
//      return getAPIUrl(link: link)!
//    } else {
//      nextTrack()
//      return ""
//    }
  }
  
  /// Is fetching content from url?
  var isLoading = false
  
  let assetQueue = DispatchQueue(label: "randomQueue", qos: .utility)
  
  let group = DispatchGroup()
  
  let assetKeysRequiredToPlay = [
    "playable"
  ]
  
  var player = AVPlayer()
  
  var AVItemPool: [String: AVPlayerItem] = [:] {
    didSet {
      print("item was added: ", self.AVItemPool.count)
      
      let currentItem = self.AVItemPool[self.currentTrackURL]
      
      //Set Observer to get notified when AVPlayer finishes the song
      NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: currentItem)
      
      if self.AVItemPool.count == 1 { //Starts playing immediately
        self.onCollectionReady.fire(true)
      }
      
      if autoPlayAfterFetch == true {
        self.player.replaceCurrentItem(with: currentItem)
        self.player.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.delegate?.readyToPlay()
        }
        
        self.autoPlayAfterFetch = false
      }
    }
  }
  
  
  var asset: AVURLAsset? {
    didSet {
      guard let newAsset = asset else { return }
      asynchronouslyLoadURLAsset(newAsset, appendDirectly: true) //onceden false idi.
    }
  }
  
  var dynamicAsset: AVURLAsset? {
    didSet {
      guard let newDAsset = dynamicAsset else { return }
      asynchronouslyLoadURLAsset(newDAsset, appendDirectly: true)
    }
  }
  
  public var duration: Double {
    guard let currentItem = player.currentItem else { return 0.0 }
    return CMTimeGetSeconds(currentItem.duration)
  }
  
  var rate: Float {
    get {
      return player.rate
    } set {
      player.rate = newValue
    }
  }
  
  /*
   A formatter for individual date components used to provide an appropriate
   value for the `startTimeLabel` and `durationLabel`.
   */
  let timeRemainingFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    
    return formatter
  }()
  
  /////////////////////  END OF INITIAL VALUES ////////////////////////////
  //MARK: - Functions
  
  /// Return if player is currently playing a track
  public func isPlaying() -> Bool {
    return self.player.rate > Float(0.0)
  }
  
  
  /// Pause playback of audio player
  public func pause() {
    self.player.pause()
//    AppNotification.shared.updatePlaylistCollectionView()
    delegate?.paused()
  }
  
  
  /// Play or Resume playback of current audio player
  public func resume() {
    self.player.play()
//    AppNotification.shared.updatePlaylistCollectionView()
    delegate?.resume()
  }
  
  
  private func setData(contents: [CategoryContentListData], startIndex: Int) {
    self.currentIndex = startIndex
    self.autoPlayAfterFetch = false
    self.trackArr = contents
  }
  
  private func preparePlayer(contents: [CategoryContentListData], startIndex: Int) {
    self.setData(contents: contents, startIndex: startIndex)
    
    playCurrentTrack()
    
    //Update Collection Views
//    AppNotification.shared.updatePlaylistCollectionView()
    
    self.setupRemoteCommandCenter()
    
    if self.observersActivated == false {
      self.setupObservers()
    }
  }
  
  
  public func prepareViewController(contents: [CategoryContentListData], startIndex: Int) {
    AppNotification.shared.presentPopupBarForViewController()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.preparePlayer(contents: contents, startIndex: startIndex)
    }
  }
  
  /// Prepare music player and present tab in MainTabBarViewController
  public func prepareTabBarController(contents: [CategoryContentListData], startIndex: Int) {
    AppNotification.shared.presentPopupBarForTabBarController()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.preparePlayer(contents: contents, startIndex: startIndex)
    }
  }
  
  public func prepare(contents: [CategoryContentListData], startIndex: Int) {
    setData(contents: contents, startIndex: startIndex)
    
    AppNotification.shared.presentPopupBarForViewController()
    
    playCurrentTrack()
    
    // Update Collection Views
//    AppNotification.shared.updatePlaylistCollectionView()
    
    self.setupRemoteCommandCenter()
    
    if self.observersActivated == false {
      self.setupObservers()
    }
  }
  
  /// Doesn't presents music popup bar. Created for CourseDetailsVC
  public func prepare(contents: [CategoryContentListData], index: Int) {
    preparePlayer(contents: contents, startIndex: index)
    
    //Update Collection Views
//    AppNotification.shared.updatePlaylistCollectionView()
  }
  
  
  
  var finishedPlayingPlaylist = false
  
  
  //MARK: - Observers
  @objc func finishedPlaying() {
    //    print("🎾🎾🎾🎾🎾🎾🎾🎾 finishedPlaying()")
    
    if currentTrack?.attributes?.id == trackArr.last?.attributes?.id {
      self.finishedPlayingPlaylist = true
    } else {
      self.finishedPlayingPlaylist = false
    }
    
    //    if trackArr.count-1 > currentIndex { //Play next song.
    //      nextTrack()
    //    }
    self.delegate?.finishedPlaying()
//    self.cellUIDelegate?.updateButtonUI(playStatus: .paused)
    AppNotification.shared.updatePlayButtonUIManually(playStatus: .paused)
  }
  
  
  /// Setup observers to monitor playback flow
  private func setupObservers() {
    self.observersActivated = true
    
    // OBSERVERS
    self.onCollectionReady.subscribe(with: self) { (isReady) in
      
      // init player queue
      let url = self.getAPIUrl(link: self.trackArr[self.currentIndex].attributes?.url)!
      self.player = AVPlayer(playerItem: self.AVItemPool[url])
      
      
      // MEDIA
      // listening for current item change
      self.audioQueueObserver = self.player.observe(\.currentItem, options: [.new]) { [self] (player, _) in
        //        print("media item changed...")
        //Update Collection Views
//        AppNotification.shared.updatePlaylistCollectionView()
      }
      
      // listening for current item status change
      self.audioQueueStatusObserver = self.player.currentItem?.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
        if playerItem.status == .readyToPlay {
          self.delegate?.readyToPlay()
        }
      })
      
      // listening for buffer is empty
      //      self.audioQueueBufferEmptyObserver = self.player.currentItem?.observe(\.isPlaybackBufferEmpty, options: [.new]) { [self] (_, _) in
      //        print("buffering...")
      //      }
      //      self.audioQueueBufferAlmostThereObserver = self.player.currentItem?.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
      //        print("buffering ends...")
      //      }
      //      self.audioQueueBufferFullObserver = self.player.currentItem?.observe(\.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
      //        print("buffering is hidden...")
      //      }
      
      self.audioQueueStallObserver = self.player.observe(\.timeControlStatus, options: [.new, .old], changeHandler: { (playerItem, change) in
        if #available(iOS 10.0, *) {
          switch (playerItem.timeControlStatus) {
          case AVPlayerTimeControlStatus.paused:
            print("Media Paused")
            if self.isLoading == false { // Prevents bug.
              // Url'den sarkiyi cekerken player pause (yani burasi) tetiklendigi icin loading animasyonu yerine paused iconu geliyordu.
//              self.cellUIDelegate?.updateButtonUI(playStatus: .paused)
              AppNotification.shared.updatePlayButtonUIManually(playStatus: .paused)
            }
            
          case AVPlayerTimeControlStatus.playing:
            print("Media Playing...")
            
            self.isLoading = false
            DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
              AppNotification.shared.updatePlayButtonUIManually(playStatus: .playing)
//              self.delegate?.startedPlaying()
            }
            self.setupObservers()
            
            
          case AVPlayerTimeControlStatus.waitingToPlayAtSpecifiedRate:
            print("Media Waiting to play at specific rate!")
            
          default:
            print("no changes")
          }
        }
      })
      
      self.audioQueueWaitingObserver = self.player.observe(\.reasonForWaitingToPlay, options: [.new, .old], changeHandler: { (playerItem, change) in
        if #available(iOS 10.0, *) {
          //          print("REASON FOR WAITING TO PLAY: ", playerItem.reasonForWaitingToPlay?.rawValue as Any)
        }
      })
      
      // INITIATE PLAYBACK #PLAY
      self.player.play()
    }
    
  }
  
  
  override init() {
    super.init()
  }
  
  deinit {
    /// Remove any KVO observer.
    self.audioQueueObserver?.invalidate()
    self.audioQueueStatusObserver?.invalidate()
    self.audioQueueBufferEmptyObserver?.invalidate()
    self.audioQueueBufferAlmostThereObserver?.invalidate()
    self.audioQueueBufferFullObserver?.invalidate()
    self.onCollectionReady.cancelAllSubscriptions()
  }
  
  
  func getSaveFileUrl(fileName: String) -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let nameUrl = URL(string: fileName)
    let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
    NSLog(fileURL.absoluteString)
    return fileURL;
  }
  
  
  func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset, appendDirectly:Bool = false) {
    /*
     Using AVAsset now runs the risk of blocking the current thread (the
     main UI thread) whilst I/O happens to populate the properties. It's
     prudent to defer our work until the properties we need have been loaded.
     */
    newAsset.loadValuesAsynchronously(forKeys: self.assetKeysRequiredToPlay) {
      /*
       The asset invokes its completion handler on an arbitrary queue.
       To avoid multiple threads using our internal state at the same time
       we'll elect to use the main thread at all times, let's dispatch
       our handler to the main queue.
       */
      DispatchQueue.main.async {
        
        /*
         Test whether the values of each of the keys we need have been
         successfully loaded.
         */
        for key in self.assetKeysRequiredToPlay {
          var error: NSError?
          
          if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
            let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
            
            let message = String.localizedStringWithFormat(stringFormat, key)
            
            self.handleErrorWithMessage(message, error: error)
            
            return
          }
        }
        
        // We can't play this asset.
        if !newAsset.isPlayable || newAsset.hasProtectedContent {
          let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
          
          self.handleErrorWithMessage(message)
          
          return
        }
        
        /*
         We can play this asset. Create a new `AVPlayerItem` and make
         it our player's current item.
         */
        if appendDirectly == false {
          self.AVItemPool[newAsset.url.absoluteString] = AVPlayerItem(asset: newAsset)
        } else {
          //          print("trying to add: ", newAsset.url)
          self.AVItemPool[newAsset.url.absoluteString] = AVPlayerItem(asset: newAsset)
        }
        
        //        self.group.leave()
      }
    }
    
  }
  
  // MARK: - Error Handling
  func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
    NSLog("Error occured with message: \(String(describing: message)), error: \(String(describing: error)).")
    
    let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
    let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")
    
    let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : message, preferredStyle: UIAlertController.Style.alert)
    
    let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
    
    let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
    
    alert.addAction(alertAction)
    
    //present(alert, animated: true, completion: nil)
    
    self.onError.fire((message: message!, error: error!))
  }
  
  // MARK: - Convenience
  func createTimeString(time: Float) -> String {
    let components = NSDateComponents()
    components.second = Int(max(0.0, time))
    
    return timeRemainingFormatter.string(from: components as DateComponents)!
  }
  
  
  //MARK: - Get Link
  func getAPIUrl(link: String?) -> String? {
    if let link = link {
      //return "\(baseLinkUrl.absoluteString)\(link)"
      return ""
    } else {
      return nil
    }
  }
  
  //MARK: - Prev Next
  
  func previousTrack() {
    if currentIndex - 1 < 0 {
      return
    } else {
      currentIndex -= 1
    }
    
    self.playCurrentTrack()
//    AppNotification.shared.updatePlaylistCollectionView()
  }
  
  func nextTrack() {
    if currentIndex + 1 >= trackArr.count {
      return
    } else {
      currentIndex += 1;
    }
    self.playCurrentTrack()
//    AppNotification.shared.updatePlaylistCollectionView()
  }
  
  internal func playCurrentTrack() {
    print("currentTrackUrl = self.currentTrackURL.url: \(self.currentTrackURL.url)")
    guard let currentTrack = currentTrack,
      let currentTrackUrl = self.currentTrackURL.url
      else {return}
    
    self.pause()
    self.finishedPlayingPlaylist = false
//    NotificationCenter.default.post(name: Notification.Name.init(AppNotification.shared.reloadCollectionViewsKey), object: nil)

    AppNotification.shared.musicIndexChanged(content: currentTrack)

    
    
    if AVItemPool[currentTrackURL] == nil { //Download
      //Check if downloaded.
      let localUrl = MusicDownloadManager.shared.getLocalURL(url: currentTrackUrl, id: currentTrack.attributes!.id!)
      
      if MusicDownloadManager.shared.isDownloaded(url: localUrl) == true { //Downloaded.
        print("🐉🐉🐉🐉🐉🐉🐉🐉🐉🐉 play downloaded file")
        playLocalFile(localUrl: localUrl)
      } else { // Fetch
        playFromUrl(url: self.currentTrackURL)
      }
    } else { //Already downloaded. Just play
      let currentItem = AVItemPool[currentTrackURL]
      NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: currentItem)
      player.replaceCurrentItem(with: currentItem)
      player.seek(to: CMTime(seconds: 0.0, preferredTimescale: 1))
      player.play()
      DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
        self.delegate?.readyToPlay()
      }
    }
  }
  
  private func playLocalFile(localUrl: URL) {
    let currentItem = AVPlayerItem(url: localUrl)
    player.replaceCurrentItem(with: currentItem)
    player.play()
    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
      self.delegate?.readyToPlay()
    }
  }
  
  private func playFromUrl(url: String) {
    self.assetQueue.async {
      self.autoPlayAfterFetch = true
      
//      self.cellUIDelegate?.updateButtonUI(playStatus: .loading)
      self.isLoading = true
      AppNotification.shared.updatePlayButtonUIManually(playStatus: .loading)
      
      
      let fileURL = NSURL(string: url)
      self.asset = AVURLAsset(url: fileURL! as URL, options: nil)
    }
  }
  
  
  //MARK: - MPRemoteCommandCenter
  func setupNowPlaying() {
    var nowPlayingInfo = [String : Any]()
    
    //Artwork
    DispatchQueue.global().async {
      if let artwork = self.getAPIUrl(link: self.currentTrack?.attributes?.thumbnail)?.url {
        if let data = try? Data.init(contentsOf: artwork) {
          if let image = UIImage(data: data) {
            let artworkImage = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_ size : CGSize) -> UIImage in
              DispatchQueue.main.async {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = image
              }
              return image
            })
            
            DispatchQueue.main.async {
              nowPlayingInfo[MPMediaItemPropertyArtwork] = artworkImage
              MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
          }
        }
      }
    }
    
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentTrack?.attributes?.title ?? ""
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentItem?.currentTime().seconds
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.currentItem?.duration.seconds
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
  
  func setupRemoteCommandCenter() {
    let commandCenter = MPRemoteCommandCenter.shared();
    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget {event in
      self.player.play()
      return .success
    }
    
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget {event in
      self.player.pause()
      
//      AppNotification.shared.updateTabBarPlayButton() //Music Player Popup's play button
//      AppNotification.shared.updateMusicPlayerPlayButtons() //BaseMusicPlayer's play button
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentItem?.currentTime().seconds
      return .success
    }
    
    commandCenter.nextTrackCommand.addTarget { event -> MPRemoteCommandHandlerStatus in
      self.nextTrack()
      return .success
    }
    
    commandCenter.previousTrackCommand.addTarget { event -> MPRemoteCommandHandlerStatus in
      self.previousTrack()
      return .success
    }
    
    commandCenter.changePlaybackPositionCommand.addTarget { event -> MPRemoteCommandHandlerStatus in
      
      if let event = event as? MPChangePlaybackPositionCommandEvent {
        let playerRate = self.player.rate
        
        self.player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
          guard let self = self else {return}
          if success {
            self.player.rate = playerRate ?? 0
          }
        })
        
        return .success
      }
      return .commandFailed
    }
    
    DispatchQueue.main.async {
      UIApplication.shared.beginReceivingRemoteControlEvents()
    }
  }
  
}

