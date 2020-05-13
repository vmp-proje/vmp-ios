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
        collectionView.register(CustomHomeCell.self, forCellWithReuseIdentifier: "MyCellId")
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCellId", for: indexPath) as! CustomHomeCell
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
      return CGSize(width: frame.width, height: 270)
    }

    
}
