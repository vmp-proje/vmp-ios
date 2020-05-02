//
//  PlaylistCollectionViewCell.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation

class PlaylistCollectionViewCell: UICollectionViewCell {
  
  
  //MARK: - Variables
  var content: CategoryContentListData?
  var communicationDelegate: CourseDetailsViewControllerCommunicationDelegate!
  var index: Int!
  var categoryName: String!
  
  override var isSelected: Bool {
    didSet {
      DispatchQueue.main.async {
        self.nameLabel.textColor = self.isSelected ? .statisticGraphicBlue : Color.appWhite
      }
    }
  }
  
  var expandDelegate: CourseDetailCollectionViewProtocol!
  
  
  //MARK: - Visual Objects
  let downloadingAnimationView: AnimationView = {
    let view = AnimationView(name: "downloading_animation")
    view.loopMode = .loop
    return view
  }()
  
  let expandButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .clear
    button.setImage(UIImage(named: "down_arrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
    
    return button
  }()
  
  let separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    
    return view
  }()
  
  let nameLabel = Label(font: AppFont.Bold.pt16, textColor: Color.appWhite, textAlignment: .left, numberOfLines: 2)
  let durationLabel = Label(font: AppFont.Regular.pt13, textColor: .lightGray, textAlignment: .left)
  var playButton = PlayButton()
  let descriptionLabel = Label(font: AppFont.Regular.pt14, textColor: .lightGray, textAlignment: .left)
  let downloadedIcon: UIImageView = {
    let icon = UIImageView()
    icon.translatesAutoresizingMaskIntoConstraints = false
    icon.image = UIImage(named: "downloaded")?.withRenderingMode(.alwaysTemplate)
    icon.tintColor = .statisticGraphicBlue
    
    return icon
  }()
  
  var didExpand: Bool! = false {
    didSet {
      if didExpand {
        expandCell()
      } else {
        narrowCell()
      }
    }
  }
  
  @objc func nothing() {}
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .clear
    loadUI()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nothing))
    descriptionLabel.addGestureRecognizer(tapGesture)
    
    expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
    
    playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
  }
  
  @objc func playButtonTapped() {
    //TODO: - o anda calan sarkiyla karsilastir. o sarkinin buttonundaysak pause-play DEGILSEK  bir alt satirdaki kodu calistir.
    if AudioPlayer.shared.currentTrack?.id == self.content?.id {//Play - Pause
      if playButton.playStatus == .playing {
        playButton.paused()
        AudioPlayer.shared.pause()
//        print("isim: \(self.nameLabel.text) - paused()")
      } else {
        playButton.playing()
        AudioPlayer.shared.resume()
//        print("isim: \(self.nameLabel.text) - playing")
      }
    } else {
        communicationDelegate.play(index: self.index)
    }
  }
  
  @objc func expandButtonTapped() {
    didExpand = !didExpand
  }
  
  func addDescriptionLabel() {
    expandButton.setImage(UIImage(named: "up_arrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
    
    descriptionLabel.removeFromSuperview()
    addSubview(descriptionLabel)
    descriptionLabel.autoPinEdge(.top, to: .bottom, of: durationLabel, withOffset: 14)
    descriptionLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 3)
    descriptionLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -2)
  }
  
  func removeDescriptionLabel() {
    expandButton.setImage(UIImage(named: "down_arrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
    descriptionLabel.removeFromSuperview()
  }
  
  func expandCell() {
    if descriptionLabel.text != "" && descriptionLabel.text != nil {
      
      expandButton.setImage(UIImage(named: "up_arrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
      
      addDescriptionLabel()
      
      self.layoutIfNeeded()
      
      let requiredHeight = descriptionLabel.requiredHeight
      expandDelegate.expandCell(index: self.index, requiredHeight: requiredHeight)
    }
  }
  
  private func narrowCell() {
    expandButton.setImage(UIImage(named: "down_arrow")!.withRenderingMode(.alwaysTemplate), for: .normal)
    descriptionLabel.removeFromSuperview()
    expandDelegate.expandCell(index: self.index, requiredHeight: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func prepareDownloadIcon(downloadState: DownloadState) {
    switch downloadState {
    case .startDownload: //Show nothing
      downloadedIcon.isHidden = true
      downloadingAnimationView.isHidden = true
    case .downloading: //Play 'Downloading' animation nothing
      playDownloadingAnimation()
    case .downloaded: //Show 'Downloaded' image
      downloadedIcon.isHidden = false
      downloadingAnimationView.isHidden = true
      downloadedIcon.image = UIImage(named: "downloaded")?.withRenderingMode(.alwaysTemplate)
    }
  }
  
  
  func prepareCell(content: CategoryContentListData?, downloadState: DownloadState, index: Int, categoryName: String) {
    self.content = content
    self.categoryName = categoryName
    self.index = index
    
    nameLabel.text = content?.attributes?.name ?? ""
    let min = (content?.attributes?.duration ?? 0) / 60
    durationLabel.text = "\(min) " + "mins".localized()
    
    //Set downloaded icon
    prepareDownloadIcon(downloadState: downloadState)
    
    if let description = content?.attributes?.description {
      descriptionLabel.text = description
      expandButton.tintColor = Color.appWhite
    } else {
      expandButton.tintColor = .lightGray
    }
  }
  
  
  //MARK: - UI
  private func playDownloadingAnimation() {
    downloadedIcon.isHidden = true
    downloadingAnimationView.isHidden = false
    downloadingAnimationView.play()
  }
  
  func loadUI() {
    addSubview(expandButton)
    expandButton.autoPinEdge(.top, to: .top, of: self, withOffset: 10)
    expandButton.autoPinEdge(.right, to: .right, of: self, withOffset: 0)
    expandButton.autoSetDimension(.height, toSize: 36)
    expandButton.autoSetDimension(.width, toSize: 36)
    
    addSubview(playButton)
    playButton.autoPinEdge(.top, to: .top, of: self, withOffset: 8)
    playButton.autoPinEdge(.left, to: .left, of: self, withOffset: 0)
    playButton.autoSetDimension(.height, toSize: 36)
    playButton.autoSetDimension(.width, toSize: 36)
    
    addSubview(downloadedIcon)
    downloadedIcon.autoPinEdge(.top, to: .top, of: playButton, withOffset: 10)
    downloadedIcon.autoPinEdge(.right, to: .left, of: expandButton, withOffset: -20)
    downloadedIcon.autoSetDimension(.height, toSize: 20)
    downloadedIcon.autoSetDimension(.width, toSize: 20)
    
    addSubview(downloadingAnimationView)
    downloadingAnimationView.autoPinEdge(.top, to: .top, of: playButton, withOffset: 10)
    downloadingAnimationView.autoPinEdge(.right, to: .left, of: expandButton, withOffset: -20)
    downloadingAnimationView.autoSetDimension(.height, toSize: 20)
    downloadingAnimationView.autoSetDimension(.width, toSize: 20)
    downloadingAnimationView.isHidden = true
    
    addSubview(nameLabel)
    nameLabel.autoPinEdge(.top, to: .top, of: playButton, withOffset: -2)
    nameLabel.autoPinEdge(.right, to: .left, of: downloadedIcon, withOffset: -6)
    nameLabel.autoPinEdge(.left, to: .right, of: playButton, withOffset: 12)
    nameLabel.autoSetDimension(.height, toSize: 40)
    
    addSubview(durationLabel)
    durationLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 0)
    durationLabel.autoPinEdge(.left, to: .left, of: nameLabel, withOffset: 0)
    durationLabel.autoPinEdge(.left, to: .right, of: playButton, withOffset: 12)
    
    addSubview(separatorView)
    separatorView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
    separatorView.autoPinEdge(.left, to: .left, of: self, withOffset: 8)
    separatorView.autoPinEdge(.right, to: .right, of: self, withOffset: 0)
    separatorView.autoSetDimension(.height, toSize: 1)
  }
}
