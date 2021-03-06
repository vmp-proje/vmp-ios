//
//  MusicView.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import YoutubeKit

class MusicView: View, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  //MARK: - Variables
  var videos: SearchVideos?
  
  var delegate: SearchProtocol!
  
  
  
  //MARK: - Visual Objects
  var player = YTSwiftyPlayer()
  
  func showPlayer() {
    addSubview(player)
    player.cornerRadius = 20
    player.layer.masksToBounds = true
    player.autoSetDimension(.height, toSize: 180)
    player.autoSetDimension(.width, toSize: 300)
    player.autoPinEdge(.right, to: .right, of: self)
    player.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
  }
  
  
  let musicCollectionView: UICollectionView = { // Scroll Up and Down
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CustomMusicCell.self, forCellWithReuseIdentifier: "MyCellId")
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setViews()
    musicCollectionView.dataSource = self
    musicCollectionView.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - Visual Objects
  override func setViews() {
    addSubview(musicCollectionView)
    
    musicCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    musicCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    musicCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    musicCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos?.items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCellId", for: indexPath) as! CustomMusicCell
    if let videoInfo = videos?.items?[indexPath.row].snippet {
      print("prepareCell worked: \(videoInfo)")
      cell.prepareCell(info: videoInfo)
    } else {
      print("prepareCell didnt work")
    }
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  //MARK: - Collection View Delegate
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let videoId = videos?.items?[indexPath.row].id?.videoId  else {return}
    self.delegate.playVideo(videoId: videoId)
  }
  
  //MARK: - Collection View Flow Layout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width, height: 130)
  }
  
  
}

//MARK: - Custom Music Cell Class

class CustomMusicCell: UICollectionViewCell {
  
  func prepareCell(info: Snippet) { //duzelt
    videoName.text = info.title
    channelName.text = info.channelTitle
    
    if let url = info.thumbnails?.medium?.url?.url {
      videoImage.kf.setImage(with: url)
    }
  }
  
  let videoName: UILabel = {
    var customlabel = UILabel()
    customlabel.translatesAutoresizingMaskIntoConstraints = false
    customlabel.text = "Eklemedir Koca Konak"
    customlabel.textColor = Color.appWhite
    customlabel.backgroundColor = .clear
    customlabel.font = .systemFont(ofSize: 18)
    customlabel.textAlignment = .left
    customlabel.adjustsFontSizeToFitWidth = true
    customlabel.minimumScaleFactor = 15
    return customlabel
  }()
  
  let channelName: UILabel = {
    var customlabel = UILabel()
    customlabel.translatesAutoresizingMaskIntoConstraints = false
    customlabel.text = "Zeynep Bastık"
    customlabel.textColor = Color.appWhite
    customlabel.backgroundColor = .clear
    customlabel.font = .systemFont(ofSize: 14)
    customlabel.textAlignment = .left // değişecek
    customlabel.adjustsFontSizeToFitWidth = true
    return customlabel
  }()
  
  let videoImage: UIImageView = {
    var imageView = UIImageView(image: UIImage(named: "image_Of_Video"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.cornerRadius = 5
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = Color.appWhite
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  
  
  //MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    setupCellViews()
  }
  
  func setupCellViews() {
    addSubview(videoImage)
    addSubview(videoName)
    addSubview(channelName)
    
    videoImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
    videoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
    videoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
    videoImage.widthAnchor.constraint(equalToConstant: (self.frame.size.width * 32) / 100).isActive = true
    
    videoName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
    //videoName.leadingAnchor.constraint(equalTo: self.videoImage.trailingAnchor, constant: 15).isActive = true
    videoName.autoPinEdge(.left, to: .right, of: videoImage, withOffset: 15)
    videoName.autoPinEdge(.right, to: .right, of: self, withOffset: -10)
    videoName.bottomAnchor.constraint(equalTo: self.channelName.topAnchor).isActive = true
    videoName.heightAnchor.constraint(equalToConstant: 70).isActive = true
    videoName.numberOfLines = 2
    
    channelName.topAnchor.constraint(equalTo: self.videoName.bottomAnchor).isActive = true
    channelName.leadingAnchor.constraint(equalTo: self.videoImage.trailingAnchor, constant: 15).isActive = true
    channelName.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -15).isActive = true
    channelName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    channelName.heightAnchor.constraint(equalToConstant: 70).isActive = true
    channelName.widthAnchor.constraint(equalToConstant: self.frame.size.width - self.videoImage.size.width).isActive = true
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

