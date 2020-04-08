//
//  AudioPlayer.swift
//  VmpProjectios
//
//  Created by Anil Joe on 8.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit
import Signals
import MediaPlayer


protocol MusicPlayerCommunicationProtocol {
  func readyToPlay()
  func musicIndexChanged(content: CategoryContentListData, author: Included?)
  func paused()
  func resume()
  func finishedPlaying()
  func startedPlaying()
}

protocol CellUIProtocol {
  func updateUIButton()
}


//MARK: - AudioPlayer
class AudioPlayer: NSObject {
  
  static let shared = AudioPlayer()
  var cellUIDelegate: CellUIProtocol?
  var delegate: MusicPlayerCommunicationProtocol?
  var currentIndex = 0
  var authors: [Included] = []
  
  ///is avPlayer is loading from url?
  //  var isLoading = true
  
  ///It's Useful when user opens songs from CollectionViews. If user tries to open songs from the same category we don't need to fetch urls over and over again. Visit TherapistColumnCell
  var categoryName: String?
  
  public var audioPlayerConfig:Dictionary<String,Any> = [
    "loop": false,
    "volume": 1.0
  ]
  
  var section_type: String = ""
  //  {
  //    didSet {
  //      print("\n\n ✅✅✅✅ section_type: \(self.section_type)")
  //    }
  //  }
  var hasBackgroundMusic: Bool {
    //    print("🌈🌈🌈🌈🌈🌈🌈🌈 hasBackgroundMusic - contentType: \(section_type)")
    if section_type == "ambience" || section_type == "music" {
      return false
    }
    return true
  }
  
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
  
  var currentType: String {
    return self.currentTrack?.attributes?.section_type ?? "music"
  }
  
  var currentTrackURL: String {
    let link = self.trackArr[currentIndex].attributes?.media
    if getAPIUrl(link: link) != nil {
      return getAPIUrl(link: link)!
    } else {
      nextTrack()
      return ""
    }
  }
  
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
    AppNotification.shared.updatePlaylistCollectionView()
    delegate?.paused()
  }
  
  
  /// Play or Resume playback of current audio player
  public func resume() {
    self.player.play()
    AppNotification.shared.updatePlaylistCollectionView()
    delegate?.resume()
  }
  
  public func prepare(contents: [CategoryContentListData], startIndex: Int, authors: [Included], presentPopupBar: Bool) {
    self.setData(contents: contents, startIndex: startIndex, authors: authors)
    
    if presentPopupBar {
      AppNotification.shared.presentPopupBarForTabBarController()
    }
//    AppNotification.shared.presentPopupBarForViewController()
    
    playCurrentTrack()
    
    //Update Collection Views
    AppNotification.shared.updatePlaylistCollectionView()
    
    self.setupRemoteCommandCenter()
    
    if self.observersActivated == false {
      self.setupObservers()
    }
  }
  
  private func setData(contents: [CategoryContentListData], startIndex: Int, authors: [Included]) {
    self.authors = authors
    self.currentIndex = startIndex
    self.autoPlayAfterFetch = false
    self.trackArr = contents
  }
  
  private func preparePlayer(contents: [CategoryContentListData], startIndex: Int, authors: [Included]) {
    self.setData(contents: contents, startIndex: startIndex, authors: authors)
    
    playCurrentTrack()
    
    //Update Collection Views
    AppNotification.shared.updatePlaylistCollectionView()
    
    self.setupRemoteCommandCenter()
    
    if self.observersActivated == false {
      self.setupObservers()
    }
  }
  
  
  public func prepareViewController(contents: [CategoryContentListData], startIndex: Int, authors: [Included]) {
    AppNotification.shared.presentPopupBarForViewController()
    self.preparePlayer(contents: contents, startIndex: startIndex, authors: authors)
  }
  
  /// Prepare music player and present tab in MainTabBarViewController
  public func prepareTabBarController(contents: [CategoryContentListData], startIndex: Int, authors: [Included]) {
    AppNotification.shared.presentPopupBarForTabBarController()
    self.preparePlayer(contents: contents, startIndex: startIndex, authors: authors)
  }
  
  public func prepare(contents: [CategoryContentListData], startIndex: Int, authors: [Included]) {
    setData(contents: contents, startIndex: startIndex, authors: authors)

//    FIXME: - bu olaya cozum bul
//        AppNotification.shared.presentPopupBarForTabBarController()
    AppNotification.shared.presentPopupBarForViewController()

    playCurrentTrack()

    // Update Collection Views
    AppNotification.shared.updatePlaylistCollectionView()

    self.setupRemoteCommandCenter()

    if self.observersActivated == false {
      self.setupObservers()
    }
  }
  
  /// Doesn't presents music popup bar. Created for CourseDetailsVC
  public func prepare(contents: [CategoryContentListData], authors: [Included], index: Int) {
    preparePlayer(contents: contents, startIndex: index, authors: authors)
    
    //Update Collection Views
    AppNotification.shared.updatePlaylistCollectionView()
  }
  
//  public func prepare(contents: [CategoryContentListData], authors: [Included], index: Int) {
//    self.authors = authors
//    self.currentIndex = index
//    self.autoPlayAfterFetch = false
//    self.trackArr = contents
//
//    playCurrentTrack()
//
//    //Update Collection Views
//    AppNotification.shared.updatePlaylistCollectionView()
//
//    self.setupRemoteCommandCenter()
//
//    if self.observersActivated == false {
//      self.setupObservers()
//    }
//  }
  
  
  
  var finishedPlayingPlaylist = false
  //MARK: - Observers
  @objc func finishedPlaying() {
    print("🎾🎾🎾🎾🎾🎾🎾🎾 finishedPlaying()")
    
    if currentTrack?.id == trackArr.last?.id {
      self.finishedPlayingPlaylist = true
    } else {
      self.finishedPlayingPlaylist = false
    }
    
    //    if trackArr.count-1 > currentIndex { //Play next song.
    //      nextTrack()
    //    }
    self.delegate?.finishedPlaying()
    self.cellUIDelegate?.updateUIButton()
    
    
    
  }
  
  
  /// Setup observers to monitor playback flow
  private func setupObservers() {
    //    print("setup observer")
    self.observersActivated = true
    
    ///OBSERVERS
    self.onCollectionReady.subscribe(with: self) { (isReady) in
      
      //      print("Are assets ready: \(isReady)")
      //      print("AVItemPool.count: \(self.AVItemPool.count)")
      // init player queue
      
      //self.player = AVPlayer(playerItem: self.AVItemPool.first!)
      let url = self.getAPIUrl(link: self.trackArr[self.currentIndex].attributes?.media)!
      self.player = AVPlayer(playerItem: self.AVItemPool[url])
      
      // MEDIA
      // listening for current item change
      self.audioQueueObserver = self.player.observe(\.currentItem, options: [.new]) { [self] (player, _) in
        //        print("media item changed..."
        //Update Collection Views
        AppNotification.shared.updatePlaylistCollectionView()
      }
      
      // listening for current item status change
      self.audioQueueStatusObserver = self.player.currentItem?.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
        if playerItem.status == .readyToPlay {
          //          print("current item status is ready")
          DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.delegate?.readyToPlay()
          })
        }
      })
      
      // listening for buffer is empty
      self.audioQueueBufferEmptyObserver = self.player.currentItem?.observe(\.isPlaybackBufferEmpty, options: [.new]) { [self] (_, _) in
        print("buffering...")
      }
      
      self.audioQueueBufferAlmostThereObserver = self.player.currentItem?.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
        print("buffering ends...")
      }
      
      self.audioQueueBufferFullObserver = self.player.currentItem?.observe(\.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
        print("buffering is hidden...")
      }
      
      self.audioQueueStallObserver = self.player.observe(\.timeControlStatus, options: [.new, .old], changeHandler: { (playerItem, change) in
        if #available(iOS 10.0, *) {
          switch (playerItem.timeControlStatus) {
          case AVPlayerTimeControlStatus.paused:
            print("Media Paused")
            self.cellUIDelegate?.updateUIButton()
            
          case AVPlayerTimeControlStatus.playing:
            print("Media Playing")
            self.cellUIDelegate?.updateUIButton()
            self.setupObservers()
            self.delegate?.startedPlaying()
            //            self.isLoading = false
            
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
    //    var audioQueueStallObserver: NSKeyValueObservation?
    //    var audioQueueWaitingObserver: NSKeyValueObservation?
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
      return "\(baseLinkUrl.absoluteString)\(link)"
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
    AppNotification.shared.updatePlaylistCollectionView()
  }
  
  func nextTrack() {
    if currentIndex + 1 >= trackArr.count {
      return
    } else {
      currentIndex += 1;
    }
    self.playCurrentTrack()
    AppNotification.shared.updatePlaylistCollectionView()
  }
  
  
  
  internal func playCurrentTrack() {
    guard let currentTrack = currentTrack,
      let currentTrackUrl = self.currentTrackURL.url
      else {return}
    
    
    self.finishedPlayingPlaylist = false
    NotificationCenter.default.post(name: Notification.Name.init(AppNotification.shared.reloadCollectionViewsKey), object: nil)
    self.section_type = currentTrack.attributes?.section_type ?? ""
    
    self.pause()
    
    let author = IncludedManager.shared.getAuthor(content: currentTrack, authors: self.authors)
    delegate?.musicIndexChanged(content: currentTrack, author: author)
    
    
    if AVItemPool[currentTrackURL] == nil { //Download
      //Check if downloaded.
      let localUrl = MusicDownloadManager.shared.getLocalURL(url: currentTrackUrl, id: currentTrack.id!)
      
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
      //      self.isLoading = true
      self.autoPlayAfterFetch = true
      let fileURL = NSURL(string: url)
      self.asset = AVURLAsset(url: fileURL! as URL, options: nil)
    }
  }
  
  
  //MARK: - MPRemoteCommandCenter
  func setupNowPlaying() {
    var nowPlayingInfo = [String : Any]()
    
    //Artwork
    DispatchQueue.global().async {
      if let artwork = self.getAPIUrl(link: self.currentTrack?.attributes?.image)?.url {
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
    
    
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentTrack?.attributes?.name ?? ""
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentItem?.currentTime().seconds //playerItem?.currentTime().seconds
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.currentItem?.duration.seconds //playerItem?.asset.duration.seconds
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
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentItem?.currentTime().seconds
      //self.playerItem?.currentTime().seconds
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

