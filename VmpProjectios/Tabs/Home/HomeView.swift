//
//  HomeView.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit
import YoutubeKit


class HomeView: View, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  
  
  
  //MARK: - Variables
  var delegate: SearchProtocol!
  let homeVC = HomeViewController()
//  var titleArray : [String] = []
//  var urlArray : [String] = []
  var videos: PopularVideos?
//  var count = 0
  
  //MARK: - Visual Objects
  var player = YTSwiftyPlayer()
  
    let flowCollectionView: UICollectionView = { // Scroll Up and Down
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomHomeCell.self, forCellWithReuseIdentifier: "myCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
  
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    print("HomeView Çalıştı")
    layoutViews()
    flowCollectionView.dataSource = self
    flowCollectionView.delegate = self
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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: - Visual Objects
  override func setViews() {
    
  }
  
  override func layoutViews() {
    addSubview(flowCollectionView)

    flowCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    flowCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    flowCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    flowCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
    
    //MARK: - Collection View Data Source
    // test
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if urlArray.isEmpty {
//            return 5
//        } else {
//            return self.urlArray.count
//        }
      return videos?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CustomHomeCell
        
        //cell.videoName.text = titleArray.item(at: indexPath.row)
//        DispatchQueue.global().async {
//            if let image = self.urlArray.item(at: indexPath.row) {
//                let data = try? Data(contentsOf: URL(string: image)!)
//                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        cell.videoImage.image = image
//                    }
//                }
//            }
//        }

//      print("✅✅✅ id: \()")
      if let videoInfo = videos?.items?[indexPath.row].snippet {
//        print("prepareCell worked: \(videoInfo)")
        cell.prepareCell(info: videoInfo)
      } else {
//        print("prepareCell didnt work")
      }
//      cell.prepareCell(info: infio)

        return cell
    }

    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print("HomeView Cell'e Tıklandı.")
      //guard let videoId = videos?.items?[indexPath.row].id?.videoId  else {return}
      guard let videoId = videos?.items?[indexPath.row].id else {return}
      delegate.playVideo(videoId: videoId)
    }
    
    //MARK: - Collection View Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: frame.width, height: 270)
    }
    
}

//MARK: - Custom Home Cell Class

class CustomHomeCell: UICollectionViewCell {
    
    let videoName: UILabel = {
        var customLabel = UILabel()
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.text = "Eklemedir Koca Konak"
        customLabel.textColor = Color.appWhite
        customLabel.backgroundColor = .clear
        customLabel.font = .systemFont(ofSize: 20)
        customLabel.textAlignment = .left
        customLabel.adjustsFontSizeToFitWidth = true
        customLabel.minimumScaleFactor = 15
        return customLabel
    }()
    
    let channelName: UILabel = {
        var customLabel = UILabel()
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customLabel.text = "Zeynep Bastık"
        customLabel.textColor = Color.appWhite
        customLabel.backgroundColor = .clear
        customLabel.font = .systemFont(ofSize: 14)
        customLabel.textAlignment = .left
        customLabel.adjustsFontSizeToFitWidth = true
        customLabel.minimumScaleFactor = 14
        return customLabel
    }()
    
    let videoImage: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "image_Of_Video"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupCellViews()
    }
    
  func prepareCell(info: Snippet) { //duzelt
    videoName.text = info.title
    channelName.text = info.channelTitle
    
    if let url = info.thumbnails?.medium?.url?.url {
      videoImage.kf.setImage(with: url)
    }
  }
  
    func setupCellViews() {
        addSubview(videoImage)
        addSubview(videoName)
        addSubview(channelName)
        // Total : 350
        videoImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        videoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        videoImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        videoImage.bottomAnchor.constraint(equalTo: videoName.topAnchor).isActive = true
        videoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        videoName.topAnchor.constraint(equalTo: videoImage.bottomAnchor).isActive = true
        videoName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        videoName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        videoName.bottomAnchor.constraint(equalTo: channelName.topAnchor).isActive = true // 275 height --- değişecek ---
        videoName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        channelName.topAnchor.constraint(equalTo: videoName.bottomAnchor).isActive = true
        channelName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        channelName.trailingAnchor.constraint(equalTo: self.trailingAnchor,  constant: -15).isActive = true
        channelName.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
//        channelTitle.topAnchor.constra
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
