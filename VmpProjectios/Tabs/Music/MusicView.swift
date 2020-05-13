//
//  MusicView.swift
//  Vmp
//
//  Created by Anil Joe on 27.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import UIKit

class MusicView: View, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //MARK: - Variables

    //MARK: - Visual Objects
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
        print("-- Width -> \(self.frame.size.width)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCellId", for: indexPath) as! CustomMusicCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }

    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print("MusicView Cell'e Tıklandı.")
    }
    
    //MARK: - Collection View Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: frame.width, height: 130)
    }

    
}

//MARK: - Custom Music Cell Class

class CustomMusicCell: UICollectionViewCell {
    
    let videoName: UITextView = {
        var customTextView = UITextView()
        customTextView.translatesAutoresizingMaskIntoConstraints = false
        customTextView.text = "Eklemedir Koca"
        customTextView.textColor = .black
        customTextView.backgroundColor = .clear
        customTextView.font = .systemFont(ofSize: 18)
        customTextView.textAlignment = .left
        customTextView.isEditable = false
        customTextView.isSelectable = false
        customTextView.isScrollEnabled = false
        customTextView.sizeToFit()
        return customTextView
    }()
    
    let channelName: UITextView = {
        var customTextView = UITextView()
        customTextView.translatesAutoresizingMaskIntoConstraints = false
        customTextView.text = "Zeynep Bastık"
        customTextView.textColor = .black
        customTextView.backgroundColor = .clear
        customTextView.font = .systemFont(ofSize: 14)
        customTextView.textAlignment = .left // değişecek
        customTextView.isEditable = false
        customTextView.isSelectable = false
        customTextView.isScrollEnabled = false
        customTextView.sizeToFit()
        return customTextView
    }()
    
    let videoImage: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "image_Of_Video"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
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
        // Total : 130
        
        videoImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        videoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        videoImage.trailingAnchor.constraint(equalTo: self.videoName.leadingAnchor).isActive = true
        videoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        videoImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        videoImage.widthAnchor.constraint(equalToConstant: (self.frame.size.width * 32) / 100).isActive = true
        
        videoName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        videoName.leadingAnchor.constraint(equalTo: self.videoImage.trailingAnchor).isActive = true
        videoName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        videoName.bottomAnchor.constraint(equalTo: self.channelName.topAnchor).isActive = true
        videoName.widthAnchor.constraint(equalToConstant: self.frame.size.width - self.videoImage.size.width).isActive = true
        videoName.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        channelName.topAnchor.constraint(equalTo: self.videoName.bottomAnchor).isActive = true
        channelName.leadingAnchor.constraint(equalTo: self.videoImage.trailingAnchor).isActive = true
        channelName.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: -15).isActive = true
        channelName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        channelName.heightAnchor.constraint(equalToConstant: 70).isActive = true
        channelName.widthAnchor.constraint(equalToConstant: self.frame.size.width - self.videoImage.size.width).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

