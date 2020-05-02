//
//  PlaylistViewController.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit


class PlaylistViewController: ViewController<CourseDetailsView>, CourseDetailsViewControllerCommunicationDelegate, DownloadButtonProtocol, CourseDetailsViewDownloadProtocol, CourseDetailCollectionViewProtocol {
  
  
  //MARK: - CourseDetailCollectionViewProtocol
  func downloadButtonTapped() {
    //Check if user is Premium
    if !isPremium {
      showUpgradeView()
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
  
  func bookmarkButtonTapped() {
    Bookmark.saveBookmark(data: self.content)
    self.customView.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
  }
  
  func learnMoreButtonTapped() {
    print("learnMoreButtonTapped()")
    guard let author = customView.author else {return}
    let therapistVC = TherapistProfileViewController(author: author)
    therapistVC.navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.pushViewController(therapistVC, animated: true)
  }
  
  func expandCell(index: Int, requiredHeight: CGFloat?) {}
  
  func expandHeaderCell(extraHeight: CGFloat) {}
  
  
  
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
      let headerCell = self.customView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CourseDetailsHeaderCollectionViewCell
      let rate = CGFloat(1.0)/CGFloat(self.customView.downloadStates.count)
      let completed = rate*CGFloat(self.completedDownloadsCount)
      headerCell?.downloadButton.state = state
      headerCell?.downloadButton.shapeLayer.strokeEnd = completed + (percentage/CGFloat(self.customView.downloadStates.count))
      
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
    guard getAPIUrl(link: customView.data[index].attributes?.media) != nil else {return}
    //FIXME: - authors goster
    AudioPlayer.shared.prepare(contents: self.customView.data, authors: [], index: index)
  }
  
  
  func hideNavigationBar() {
    navigationController?.navigationBar.alpha = 0 // Hide Navigation Bar
  }
  
  func showNavigationBar() {
    navigationController?.navigationBar.alpha = 1 // Show Navigation Bar
  }
  
  
  //MARK: - Constants
  let reachability = try! Reachability()
  let className = "CourseDetailsViewController.swift"
  
  
  //MARK: - Variables
  var content: CategoryContentListData!
  var parentContentId: String!
  var subContentId: String?
  var playlistDownloaded: Bool = false
  var isDownloading = false {
    didSet {
      if isDownloading == true {
        startInternetNotification()
      }
    }
  }
  
  
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
    
    if AudioPlayer.shared.isPlaying() == true {
      presentMusicPlayerView {}
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let leftScreenEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    leftScreenEdgeGestureRecognizer.addTarget(self, action:#selector(goBack))
    leftScreenEdgeGestureRecognizer.edges = .left
    leftScreenEdgeGestureRecognizer.cancelsTouchesInView = true
    self.view.addGestureRecognizer(leftScreenEdgeGestureRecognizer)
    
    NotificationCenter.default.addObserver(self, selector: #selector(updatePlaylist), name: NSNotification.Name.init(AppNotification.shared.updatePlaylistCollectionViewKey), object: nil)
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerFullScreen), name: NSNotification.Name.init("MusicPlayerFullScreenOpenedNotification"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerFullScreenClosed), name: NSNotification.Name.init("MusicPlayerFullScreenClosedNotification"), object: nil)
    
    // Set Delegates
    MusicDownloadManager.shared.playlistDownloadDelegate = self
    customView.communicationDelegate = self
    customView.collectionViewDelegate = self
    
    canShowMusicPlayerPopupBar = false
    //    canShowMusicPlayerPopupBar = true // Music Player shouldn't be presented from ViewController.swift class. Because we will present it in here with navigationController.
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      if self.subContentId != nil {
        //Present Music player
        self.presentMusicPlayerView {
          
          // Fetch data and play
          if self.content == nil {
            self.getSingleContent(id: self.parentContentId)
          }
          self.startLoadingAnimation()
          self.subContentList(id: self.parentContentId, page: 1)
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
//      print("🦷🦷🦷🦷 present music popup")
      completion()
    }
  }
  
  
  
  //MARK: - Data
  private func getSingleContent(id: String) {
    startLoadingAnimation()
    
    ContentManager.shared.getSingleContent(id: id).done { (singleContent) in
      self.stopLoadingAnimation()
      
      if let content = singleContent.data {
        
        self.content = content
        
        // Update UI
        self.customView.base_content = content
        self.customView.categoryName = content.attributes?.name ?? ""
        self.customView.headerData = content.attributes
        self.customView.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
      }
    }.catch { (error) in
      Debugger.logError(message: "\(self.className) getContentRecommendationList() failed", data: error)
      ShowErrorMessage.statusLine(message: "Error:".localized() + "\(error.localizedDescription)")
      self.stopLoadingAnimation()
      //      self.dismissVC()
    }
  }
  
  private func subContentList(id: String, page: Int) {
    //    startLoadingAnimation()
    print("\n\n subContentList(id: \(id), page: \(page)")
    
    ContentManager.shared.subContentList(id: id, page: page).done { (contentRecommendationList) in
      //      self.stopLoadingAnimation()
      
      if let data = contentRecommendationList.data {
        self.customView.data.append(contentsOf: data)
        
        if page == 1 { //
          if let subContentId = self.subContentId { // Start playing automatically
            if let index = self.getIndex(id: subContentId) {
              self.play(index: index)
            }
          }
          let author = contentRecommendationList.included?.first
          self.customView.author = author
        }
        
        if contentRecommendationList.links?.next != nil { // keep fetch
          self.subContentList(id: id, page: page+1)
          print("yeniden data cek -> page: \(page+1)")
        } else { //Finished fetching
          // Update Download Button's UI
          self.customView.collectionView.reloadData()
          self.updatePlaylistDownloadButton(data: data)
          self.stopLoadingAnimation()
          return
        }
        
        
      }
      
    }.catch { (error) in
      Debugger.logError(message: "\(self.className) getContentRecommendationList() failed", data: error)
      ShowErrorMessage.statusLine(message: "Error:".localized() + "\(error.localizedDescription)")
      self.stopLoadingAnimation()
    }
  }
  
  func updatePlaylistDownloadButton(data: [CategoryContentListData]) {
    var downloadedCount: Int = 0
    self.customView.downloadStates = []
    
    for content in data { //Check if contents downloaded (one by one)
      if let apiUrl = getAPIUrl(link: content.attributes?.media) {
        let downloadState = MusicDownloadManager.shared.getDownloadState(content: content, apiUrl: apiUrl)
        customView.downloadStates.append(downloadState) //For playlist collection view
        if downloadState == .downloaded {
          downloadedCount += 1
        }
      } else {
        customView.downloadStates.append(.startDownload)
      }
    }
    
    //Update Download Button's UI
    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { // wait for ui to load
      let headerCell = self.customView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CourseDetailsHeaderCollectionViewCell
      if downloadedCount == data.count { //Playlist Downloaded
        headerCell?.downloadButton.state = .downloaded
        headerCell?.downloadButton.shapeLayer.strokeEnd = DownloadState.downloaded.getPercentage()
        self.playlistDownloaded = true
      } else {
        let rate = CGFloat(1.0)/CGFloat(self.customView.downloadStates.count)
        let completed = rate*CGFloat(self.completedDownloadsCount)
        //        headerCell?.downloadButton.state = .startDownload
        headerCell?.downloadButton.shapeLayer.strokeEnd = completed
        self.playlistDownloaded = false
      }
    }
    
  }
  
  
  //MARK: - Internet Connection
  @objc func reachabilityChanged(note: Notification) {
    let reachability = note.object as! Reachability
    
    switch reachability.connection {
    case .unavailable:
      internetConnectionLost()
    case .none:
      return
    default: //Connected to Internet
      MusicDownloadManager.shared.resumeDownloads()
    }
  }
  
  func startInternetNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
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
