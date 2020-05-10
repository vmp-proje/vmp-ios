//
//  GlobalSearchView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import YoutubeKit

class GlobalSearchView: View {
  
  
  //MARK: - Protocol
  //  var delegate: Protocol!
  
  var player = YTSwiftyPlayer()
  
  
  //MARK: - Contents
  let cellId = "cellId"
  
  
  //MARK: - Variables
  var videos: PopularVideos?
  
  
  //MARK: - Visual Objects
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 15
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = .clear
    cv.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
    
    return cv
  }()
  
  var activityIndicatorView = NVActivityIndicatorView(frame: UIScreen.main.bounds, type: .circleStrokeSpin, color: .white, padding: 0)
  
  let backgroundView: UIView = {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
    return view
  }()
  
  let warningLabel = Label(text: "No results found.".localized(), font: AppFont.Regular.font(size: 15), textColor: .gray, textAlignment: .center, numberOfLines: 0)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    collectionView.register(SearchColllectionViewCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.delegate = self
    collectionView.dataSource = self
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    loadUI()
  }
  
  var keyboardHeight: CGFloat = 0
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let keyboardHeight = keyboardSize.height
      self.keyboardHeight = keyboardHeight
      //            layoutAnimView()
    }
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setVideos(videos: PopularVideos) {
    self.videos = videos
    
    print("setVideos: \(videos.items?.count)")
    if videos.items?.count ?? 0 == 0 {
      showErrorLabel()
    } else {
      hideErrorLabel()
      //      DispatchQueue.main.async {
      
      print("reload: \(videos.items?.count)")
      self.collectionView.reloadData()
      self.endEditing(true)
      //      }
    }
  }
  
  func showErrorLabel() {
    self.warningLabel.isHidden = false
    self.collectionView.isHidden = true
  }
  
  func hideErrorLabel() {
    self.warningLabel.isHidden = true
    self.collectionView.isHidden = false
  }
  
  
  override func startLoading() {
    self.backgroundView.isHidden = false
    self.activityIndicatorView.startAnimating()
  }

  override func stopLoading() {
    self.activityIndicatorView.stopAnimating()
    self.backgroundView.isHidden = true
  }
  
  func showPlayer() {
    addSubview(player)
    player.cornerRadius = 20
    player.layer.masksToBounds = true
    player.autoSetDimension(.height, toSize: 180)
    player.autoSetDimension(.width, toSize: 300)
    player.autoPinEdge(.right, to: .right, of: self)
    player.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
  }
  
  func loadUI() {
    addSubview(collectionView)
    addSubview(warningLabel)
    addSubview(backgroundView)
    addSubview(activityIndicatorView)
    
    collectionView.autoPinEdge(toSuperviewSafeArea: .top)
    collectionView.autoPinEdge(.left, to: .left, of: self)
    collectionView.autoPinEdge(.right, to: .right, of: self)
    collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
    
    warningLabel.anchorCenterYToSuperview(constant: 10)
    warningLabel.autoPinEdge(.left, to: .left, of: self)
    warningLabel.autoPinEdge(.right, to: .right, of: self)
    warningLabel.autoSetDimension(.height, toSize: 75)
    warningLabel.isHidden = true
    
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.anchorCenterYToSuperview(constant: -5)
    activityIndicatorView.autoSetDimension(.width, toSize: 70)
    activityIndicatorView.autoSetDimension(.height, toSize: 70)
    activityIndicatorView.anchorCenterXToSuperview()
    
    backgroundView.autoPinEdge(toSuperviewSafeArea: .top)
    backgroundView.autoPinEdge(.bottom, to: .bottom, of: self)
    backgroundView.autoPinEdge(.left, to: .left, of: self)
    backgroundView.autoPinEdge(.right, to: .right, of: self)
//    backgroundView.isHidden = true
  }
  var delegate: SearchProtocol!
}





extension GlobalSearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("count: \(videos?.items?.count ?? 0)")
    return videos?.items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchColllectionViewCell
    if let videoInfo = videos?.items?[indexPath.row].snippet {
      print("prepareCell worked: \(videoInfo)")
      cell.prepareCell(info: videoInfo)
    } else {
      print("prepareCell didnt work")
    }
    //    cell.communicationDelegate = self
    
    return cell
  }
  
  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
    return CGSize(width: screenSize.width-40, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 18
  }
  
  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
  }
  
  
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let videoId = videos?.items?[indexPath.row].id?.videoId  else {return}
    self.delegate.playVideo(videoId: videoId)
  }
  
}
