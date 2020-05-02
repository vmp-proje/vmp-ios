//
//  PlaylistViewController.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit

protocol CourseDetailsViewDownloadProtocol {
  func updatePlaylist()
}

class PlaylistViewController: ViewController<PlaylistView>, DownloadButtonProtocol, CourseDetailsViewDownloadProtocol { //CourseDetailCollectionViewProtocol
  
  
  //MARK: - CourseDetailCollectionViewProtocol
  func downloadButtonTapped() {
    //Check if user is Premium
    if !isPremium {
      self.showUpgradeView()
      return
    }
    
    if playlistDownloaded == false { // Download playlist
      if isDownloading {
        MusicDownloadManager.shared.cancelDownloads(data: customView.data, removeDownloadedFiles: false)
        isDownloading = false
      } else {
        MusicDownloadManager.shared.prepare(queue: customView.data)
        
        //Update customView's Download states
        updatePlaylistDownloadButton(data: self.customView.data)
        isDownloading = true
      }
    } else { // Remove playlist
      self.showAlert(title: "Remove from Downloads?".localized(), message: "You won't be able to play this offline.".localized(), buttonTitles: ["Cancel".localized(), "Remove".localized()], highlightedButtonIndex: 0) { (index) in
        if index == 1 { // Remove song
          MusicDownloadManager.shared.cancelDownloads(data: self.customView.data, removeDownloadedFiles: true)
          self.isDownloading = false
        }
      }
    }
  }
  
  
  //MARK: - CourseDetailsViewDownloadProtocol
  @objc func updatePlaylist() {
    DispatchQueue.main.async {
      self.updatePlaylistDownloadButton(data: self.customView.data)
      self.customView.collectionView.reloadSections(IndexSet(arrayLiteral: 1))
    }
  }
  
  
  
  //MARK: - DownloadButtonProtocol
  //  var printCount = 0
  func updateButton(state: DownloadState, percentage: CGFloat, url: URL?) {
    DispatchQueue.main.async {
      let headerCell = self.customView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? PlaylistHeaderCollectionViewCell
      let rate = CGFloat(1.0)/CGFloat(self.customView.downloadStates.count)
      let completed = rate*CGFloat(self.completedDownloadsCount)
//      headerCell?.downloadButton.state = state
//      headerCell?.downloadButton.shapeLayer.strokeEnd = completed + (percentage/CGFloat(self.customView.downloadStates.count))
      
      
      
      
      //
      //
      //  TEST, PRINT
      //
      //
      
      
      //      var isNil = false
      //      if headerCell == nil {
      //        isNil = true
      //      }
      //      let result = completed + (percentage/CGFloat(self.customView.downloadStates.count))
      //      if self.printCount % 30 == 0 {
      //        print("🔥🔥🔥 rate: \(rate) --- completedDownloadsCount:\(self.completedDownloadsCount) --- completed:\(completed) ----- totalDownloadingCount: \(self.totalDownloadingItemCount) == result: \(result) --- percentage: \(percentage)")
      //      }
      //      self.printCount += 1
      
    }
  }
  
  func updateButton(state: DownloadState) {}
  
  
  
  //MARK: - CourseDetailsViewControllerCommunicationDelegate
  private func getIndex(id: String) -> Int? {
    let index = self.customView.data.firstIndex(where: {$0.id == id})
    return index
  }
  
  func play(index: Int) {
//    AudioPlayer.shared.prepare(contents: self.customView.data, authors: [], index: index)
  }
  
  
  
  //MARK: - Constants
  let className = "CourseDetailsViewController.swift"
  
  
  
  //MARK: - Variables
  var content: CategoryContentListData!
  
  var parentContentId: String!
  
  var subContentId: String?
  
  var playlistDownloaded: Bool = false
  
  var isDownloading = false

  
  
  @objc func internetConnectionLost() {
    showAlert(title: nil, message: "You don't have internet connection at the moment.".localized())
  }
  
  var completedDownloadsCount: Int {
    let states = customView.downloadStates
    return states.filter{$0 == .downloaded}.count
  }
  
  var totalDownloadingItemCount: Int! {
    let states = customView.downloadStates
    return states.filter{$0 != .downloaded}.count
  }
  
  var downloadingItemCount: Int! {
    return totalDownloadingItemCount-completedDownloadsCount
  }
  
  var navigationBarHeight: CGFloat {
    return self.topbarHeight
  }
  
  
  
  //MARK: - Initialization
  init(content: CategoryContentListData) {
    self.content = content
    //    self.parentContentId = content.id!
    
    super.init(nibName: nil, bundle: nil)
    
    customView.base_content = content
    customView.categoryName = self.content.attributes?.name ?? ""
    customView.headerData = content.attributes
  }
  
  /// Works when user comes from the sub-content of the collection view
  init(parentContentId: String, subContentId: String?) {
    self.parentContentId = parentContentId
    self.subContentId = subContentId
    
    super.init(nibName: nil, bundle: nil)
  }
  
  
  
  //MARK: - View Appereance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    
    //Setup header view
    customView.navigationBarHeight = self.navigationBarHeight
    setupNavigationBar()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //FIXME: - geri ekle
//    if AudioPlayer.shared.isPlaying() == true {
//      presentMusicPlayerView {}
//    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let leftScreenEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer()
//    leftScreenEdgeGestureRecognizer.addTarget(self, action:#selector(goBack))
//    leftScreenEdgeGestureRecognizer.edges = .left
//    leftScreenEdgeGestureRecognizer.cancelsTouchesInView = true
//    self.view.addGestureRecognizer(leftScreenEdgeGestureRecognizer)
    
    
//    NotificationCenter.default.addObserver(self, selector: #selector(updatePlaylist), name: NSNotification.Name.init(AppNotification.shared.updatePlaylistCollectionViewKey), object: nil)
    

    
    // Set Delegates
    MusicDownloadManager.shared.playlistDownloadDelegate = self
//    customView.communicationDelegate = self
//    customView.collectionViewDelegate = self
    
    canShowMusicPlayerPopupBar = false
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      if self.subContentId != nil {
        //Present Music player
        self.presentMusicPlayerView {
        }
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  @objc func musicPlayerFullScreen() {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  @objc func musicPlayerFullScreenClosed() {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  //MARK: - Music Player Popup
  func presentMusicPlayerView(completion: @escaping() -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { //Prevents bug.
      self.navigationController?.popupBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      self.navigationController?.presentPopupBar(withContentViewController: self.musicPlayerVC, animated: true, completion: nil)
      self.customView.showBottomViewForMusicPlayer()
      completion()
    }
  }
  
  
  
  //MARK: - Data
  func updatePlaylistDownloadButton(data: [CategoryContentListData]) {
//    var downloadedCount: Int = 0
//    self.customView.downloadStates = []
//
//    for content in data { //Check if contents downloaded (one by one)
//      if let apiUrl = getAPIUrl(link: content.attributes?.media) {
//        let downloadState = MusicDownloadManager.shared.getDownloadState(content: content, apiUrl: apiUrl)
//        customView.downloadStates.append(downloadState) //For playlist collection view
//        if downloadState == .downloaded {
//          downloadedCount += 1
//        }
//      } else {
//        customView.downloadStates.append(.startDownload)
//      }
//    }
//
//    //Update Download Button's UI
//    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { // wait for ui to load
//      let headerCell = self.customView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CourseDetailsHeaderCollectionViewCell
//      if downloadedCount == data.count { //Playlist Downloaded
//        headerCell?.downloadButton.state = .downloaded
//        headerCell?.downloadButton.shapeLayer.strokeEnd = DownloadState.downloaded.getPercentage()
//        self.playlistDownloaded = true
//      } else {
//        let rate = CGFloat(1.0)/CGFloat(self.customView.downloadStates.count)
//        let completed = rate*CGFloat(self.completedDownloadsCount)
//        //        headerCell?.downloadButton.state = .startDownload
//        headerCell?.downloadButton.shapeLayer.strokeEnd = completed
//        self.playlistDownloaded = false
//      }
//    }
    
  }

  
  
  @objc func dismissVC() {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  //MARK: - Dark Mode
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    //Debug: After switching dark modes download button resets it self.
    updatePlaylistDownloadButton(data: self.customView.data)
  }
  
  
  //MARK: - Navigation Bar
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    
    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    backButton.setTitleColor(.black, for: .normal)
    let arrowImg = UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate)
    backButton.setImage(arrowImg, for: .normal)
    backButton.imageView?.tintColor = Color.appWhite
    backButton.layer.masksToBounds = true
    backButton.layer.cornerRadius = 20
    backButton.backgroundColor = UIColor.buttonBlurryBackground
    backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    let backBarButton = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = backBarButton
    
    if isPremium == false {
      let lockIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
      lockIcon.translatesAutoresizingMaskIntoConstraints = false
      lockIcon.image = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
      lockIcon.contentMode = .scaleAspectFill
      lockIcon.tintColor = .white
      let lockIconBarButton = UIBarButtonItem(customView: lockIcon)
      navigationItem.rightBarButtonItem = lockIconBarButton
    }
    
  }
}


extension UIViewController {
  /// Height of status bar + navigation bar (if navigation bar exist)
  var topbarHeight: CGFloat {
    if #available(iOS 13.0, *) {
      return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    } else {
      return UIApplication.shared.statusBarFrame.size.height +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
  }
}
