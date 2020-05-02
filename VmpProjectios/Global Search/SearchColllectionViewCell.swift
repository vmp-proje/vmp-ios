//
//  SearchColllectionViewCell.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
class SearchColllectionViewCell: UICollectionViewCell {
  
  //let imageView = AnimatedProfileImageView(frame: .zero)
  let imageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  let nameLabel = Label(font: AppFont.Medium.font(size: 15), textColor: Color.appWhite, textAlignment: .left)
//  let uNameLabel = AppLabel(font: Font.Regular.font(size: 15), textColor: .grayTextColor, textAlignment: .left)
  
  

  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadUI()
    
    layer.cornerRadius = 15
    layer.borderWidth = 1
    layer.masksToBounds = true
    layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
    
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 30
  
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
//    imageView.addGestureRecognizer(tapGesture)
  }
  
  
//  @objc func imageViewTapped() {
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func prepareCell(info: Int) { //duzelt
    nameLabel.text = "sdgljndsgljsdnglj sdg"
    imageView.image = UIImage(named: "profile_photo")
//    self.user = user
//
//    imageView.imageView.kf.setImage(with: user.getProfilePictureLink())
//    nameLabel.text = user.name ?? ""
    
//    if user.getLatestReelMedia() != 0 {
//      imageView.hasStory = true
//      imageView.isUserInteractionEnabled = true
//    } else {
//      imageView.isUserInteractionEnabled = false
//      imageView.hasStory = false
//    }
  }
  
  
  private func loadUI() {
    addSubview(imageView)
    addSubview(nameLabel)
//    addSubview(uNameLabel)
//    addSubview(separatorView)
    
    imageView.autoPinEdge(.left, to: .left, of: self, withOffset: 12)
    imageView.autoSetDimension(.height, toSize: 57)
    imageView.autoSetDimension(.width, toSize: 57)
    imageView.anchorCenterYToSuperview()
    
    nameLabel.autoPinEdge(.top, to: .top, of: imageView, withOffset: 8)
    nameLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 15)
    nameLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -110)
    nameLabel.autoSetDimension(.height, toSize: 20)
    
//    uNameLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 3)
//    uNameLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 15)
//    uNameLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -110)
//    uNameLabel.autoSetDimension(.height, toSize: 17)

//    separatorView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
//    separatorView.autoPinEdge(.left, to: .left, of: self, withOffset: 0)
//    separatorView.autoPinEdge(.right, to: .right, of: self, withOffset: 0)
//    separatorView.autoSetDimension(.height, toSize: 1)
  }
}
