//
//  SearchColllectionViewCell.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//


import UIKit
import Kingfisher


class SearchColllectionViewCell: UICollectionViewCell {
  
  
  //MARK: - Visual Objects
  //let imageView = AnimatedProfileImageView(frame: .zero)
  let imageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let nameLabel = Label(font: AppFont.Medium.font(size: 16), textColor: Color.appWhite, textAlignment: .left)
  
  let channelNameLabel = Label(font: AppFont.Light.font(size: 12), textColor: .gray, textAlignment: .left)
  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadUI()
    
//    layer.cornerRadius = 18
//    layer.borderWidth = 2
//    layer.masksToBounds = true
//    layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
    
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 7
  
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
//    imageView.addGestureRecognizer(tapGesture)
  }
  
  
//  @objc func imageViewTapped() {
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func prepareCell(info: Snippet) { //duzelt
    nameLabel.text = info.title
    channelNameLabel.text = info.channelTitle
    
    if let url = info.thumbnails?.medium?.url?.url {
      imageView.kf.setImage(with: url)
    }
  }
  
  
  private func loadUI() {
    addSubview(imageView)
    addSubview(nameLabel)
    addSubview(channelNameLabel)
    addSubview(separatorView)
    
    imageView.autoPinEdge(.left, to: .left, of: self, withOffset: 12)
    imageView.autoSetDimension(.height, toSize: 57)
    imageView.autoSetDimension(.width, toSize: 57)
    imageView.anchorCenterYToSuperview()
    
    nameLabel.autoPinEdge(.top, to: .top, of: imageView, withOffset: 8)
    nameLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 15)
    nameLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -20)
    nameLabel.autoSetDimension(.height, toSize: 20)
    
    channelNameLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 3)
    channelNameLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 15)
    channelNameLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -110)
    channelNameLabel.autoSetDimension(.height, toSize: 17)

    separatorView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
    separatorView.autoPinEdge(.left, to: .left, of: self, withOffset: 0)
    separatorView.autoPinEdge(.right, to: .right, of: self, withOffset: 0)
    separatorView.autoSetDimension(.height, toSize: 1)
  }
}
