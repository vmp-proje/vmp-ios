import Foundation
import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
  
  //MARK: - UI Objects
  let titleOfContent : UITextView = {
    var textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = .systemFont(ofSize: 18)
    textView.textColor = .white
    textView.text = "Eklemedir Koca Konak"
    textView.backgroundColor = .clear
    textView.isSelectable = false
    textView.isScrollEnabled = false
    textView.isEditable = false
    return textView
  }()
  
  let nameOfYoutubeChannel : UITextView = {
    var textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.font = .systemFont(ofSize: 14)
    textView.textColor = .lightGray
    textView.text = "Zeynep Bastık - 4.2M views"
    textView.backgroundColor = .clear
    textView.isSelectable = false
    textView.isScrollEnabled = false
    textView.isEditable = false
    return textView
  }()
  
  let imageOfVideo : UIImageView = {
    var customImageView = UIImageView()
    customImageView.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "image_Of_Video")
    customImageView.image = image
    customImageView.layer.cornerRadius = 10
    customImageView.layer.masksToBounds = true
    return customImageView
  }()
  
  //MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  
  //MARK: - UI Layout
  func setupViews() {
    addSubview(imageOfVideo)
    addSubview(titleOfContent)
    addSubview(nameOfYoutubeChannel)
    
    imageOfVideo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    imageOfVideo.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    imageOfVideo.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    imageOfVideo.bottomAnchor.constraint(equalTo: titleOfContent.topAnchor).isActive = true
    
    titleOfContent.topAnchor.constraint(equalTo: imageOfVideo.bottomAnchor).isActive = true
    titleOfContent.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    titleOfContent.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    titleOfContent.bottomAnchor.constraint(equalTo: nameOfYoutubeChannel.topAnchor).isActive = true
    titleOfContent.heightAnchor.constraint(equalToConstant: 27).isActive = true
    
    nameOfYoutubeChannel.topAnchor.constraint(equalTo: titleOfContent.bottomAnchor).isActive = true
    nameOfYoutubeChannel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    nameOfYoutubeChannel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    nameOfYoutubeChannel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    nameOfYoutubeChannel.heightAnchor.constraint(equalToConstant: 27).isActive = true
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
