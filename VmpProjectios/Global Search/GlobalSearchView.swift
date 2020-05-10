//
//  GlobalSearchView.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class GlobalSearchView: View {

  
  //MARK: - Protocol
//  var delegate: Protocol!


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
    
    //        setupAnimationView()
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  var keyboardHeight: CGFloat = 0
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let keyboardHeight = keyboardSize.height
      print("\n\n keyboardHeight: \(keyboardHeight)")
      self.keyboardHeight = keyboardHeight
      //            layoutAnimView()
    }
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  func setVideos(videos: PopularVideos) {
    self.videos = videos
    
    if videos.items?.count ?? 0 == 0 {
      showErrorLabel()
    } else {
      hideErrorLabel()
      DispatchQueue.main.async {
        self.collectionView.reloadData()
        self.endEditing(true)
      }
    }
  }
  
  func showErrorLabel() {
    DispatchQueue.main.async {
      
      self.warningLabel.isHidden = false
      self.collectionView.isHidden = true
    }
  }
  
  func hideErrorLabel() {
    DispatchQueue.main.async {
      self.warningLabel.isHidden = true
      self.collectionView.isHidden = false
    }
  }
  

  override func startLoading() {
    DispatchQueue.main.async {
      self.backgroundView.isHidden = false
    }
  }
  
  override func stopLoading() {
    DispatchQueue.main.async {
      self.activityIndicatorView.stopAnimating()
      self.backgroundView.isHidden = true
    }
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
    backgroundView.isHidden = true
  }
}





extension GlobalSearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return videos?.items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchColllectionViewCell
    if let videoInfo = videos?.items?[indexPath.row].snippet {
      cell.prepareCell(info: videoInfo)
    }
//    cell.communicationDelegate = self
//    cell.setInfo(user: user)
//    cell.prepareCell(info: 0)
    cell.backgroundColor = .red
    
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
//    guard let userPk = users[indexPath.row].pk()  else {
//      return
//    }
//    self.delegate.
  }
  
}
