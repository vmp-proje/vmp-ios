//
//  PlaylisitView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit

class PlaylistView: View, CourseDetailCollectionViewProtocol, CourseDetailsViewControllerCommunicationDelegate {
  
  
  
  //MARK: - CourseDetailsViewControllerCommunicationDelegate
  func play(index: Int) {
    self.communicationDelegate.play(index: index)
  }
  
  
  
  //MARK: - Scroll View
  
  //MARK: - CourseDetailCollectionViewProtocol
  func downloadButtonTapped() {
    collectionViewDelegate.downloadButtonTapped()
  }
  
  func expandHeaderCell(extraHeight: CGFloat) {
    if headerCellHeight == 560 { //Expandable
      headerCellHeight += extraHeight
    } else { //Narrow
      headerCellHeight = 560
    }
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  func expandCell(index: Int, requiredHeight: CGFloat?) {
    expandedCellInfo[index] = requiredHeight
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  
  
  //MARK: - Constants
  let playlistCellId = "playListCellId"
  let headerCellId = "headerCellId"
  
  
  
  //MARK: - Variables
  var downloadButtonDelegate: DownloadButtonProtocol!
  
  
  var categoryName: String?
  
  var headerCellHeight: CGFloat = 560
  
  var playlistCellWidth: CGFloat = screenSize.width-48
  
  var playlistCellHeight: CGFloat = 80
  
  var authorCellHeight: CGFloat = 290
  
  var base_content: CategoryContentListData?
  
  var author: Included?
  
  var data: [CategoryContentListData] = []

  
  var downloadStates: [DownloadState] = []
  
  var headerData: CategoryContentListAttributes! {
    didSet {
      collectionView.reloadData()
    }
  }
  /// Height constraint for CourseDetailsHeaderView
  var headerViewHeightConstraint: NSLayoutConstraint!
  
  var expandedCellInfo: [Int:CGFloat] = [:]
  
  var navigationBarHeight: CGFloat!
  
  
  
  //MARK: - Visual Objects
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    
    return cv
  }()
  
  private func setupCollectionView() {
    collectionView.showsVerticalScrollIndicator = false
    collectionView.backgroundColor = .clear
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(PlaylistHeaderCollectionViewCell.self, forCellWithReuseIdentifier: headerCellId)
    collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: playlistCellId)
  }
  
  //MARK: Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - UI
  override func setViews() {
    addSubview(collectionView)
  }
  
  override func layoutViews() {
    collectionView.autoPinEdge(.top, to: .top, of: self)
    collectionView.autoPinEdge(.left, to: .left, of: self)
    collectionView.autoPinEdge(.right, to: .right, of: self)
    collectionView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
  }
  
}



//MARK: - Collection View Extensions
extension PlaylistView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 1 {
      return data.count
    }
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.section == 0 { // Header
      let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellId, for: indexPath) as! PlaylistHeaderCollectionViewCell
      if let headerData = self.headerData {
        headerCell.prepareCell(attributes: headerData, isDetail: true)
      }
      
      return headerCell
    } else { //Playlist
      let playlistCell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCellId, for: indexPath) as! CourseDetailsCollectionViewCell
      playlistCell.communicationDelegate = self
      let data = self.data[indexPath.row]
      
      if expandedCellInfo[indexPath.row] != nil {
        playlistCell.addDescriptionLabel()
      } else {
        playlistCell.removeDescriptionLabel()
      }
      
      //Set Play Button's Icon
      playlistCell.playButton.paused()
      // Does music cell playing this cell's content ATM?
      
      
      if AudioPlayer.shared.currentTrack?.id == data.id {
        if AudioPlayer.shared.isPlaying() == true {
          playlistCell.playButton.playing()
        }
        playlistCell.isSelected = true
      } else {
        playlistCell.isSelected = false
      }
      
      // Get Download State
      let downloadState = self.downloadStates[indexPath.row]
      
      //Set Info
      playlistCell.prepareCell(content: data, downloadState: downloadState, index: indexPath.row, categoryName: self.categoryName ?? "")
      
      return playlistCell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 0 {
      return CGSize(width: screenSize.width, height: headerCellHeight)
    } else if indexPath.section == 1 { // Songs
      if let requiredHeight = expandedCellInfo[indexPath.row] {
        return CGSize(width: playlistCellWidth, height: playlistCellHeight+requiredHeight+16)
      }
      return CGSize(width: playlistCellWidth, height: playlistCellHeight)
    } else { // Author
      return CGSize(width: playlistCellWidth, height: authorCellHeight)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if section == 0 {
      return UIEdgeInsets(top: -self.safeAreaInsets.top, left: 0, bottom: 24, right: 0)
    }
    return UIEdgeInsets(top: 0, left: 0, bottom: 35, right: 0)

  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //Play Music
    if indexPath.section == 1 {
      self.communicationDelegate.play(index: indexPath.row)
    }
  }
}
