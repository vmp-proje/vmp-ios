import  Foundation
import UIKit

class ProfileView: View {
    //MARK: - UI Objects
    
    let profileView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let profileImage: UIImageView = { // Give padding to image
        let imageView = UIImageView(image: UIImage(named: "profile_photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 4.0
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemPurple.cgColor
        imageView.layer.cornerRadius = 160 / 2.0
        return imageView
    }()
    
    let profileUserName: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Jonathan Livingston"
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 30)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()
    
    let profileMailAdress: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "jonny.live@gmail.com"
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        return textView
    }()

    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileLayoutView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

       //MARK: - UI
       
       func profileLayoutView() {
           addSubview(profileView)
           
           profileView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
           profileView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
           profileView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
           profileView.heightAnchor.constraint(equalToConstant: 300).isActive = true
           
           profileView.addSubview(profileImage)
           profileView.addSubview(profileUserName)
           profileView.addSubview(profileMailAdress)
           
           //profileImage
           profileImage.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 15).isActive = true
           profileImage.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
           profileImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
           profileImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
           
//           profileImage.layer.cornerRadius = 160 / 2.0
           
           //profileUserName
           profileUserName.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
           profileUserName.leadingAnchor.constraint(equalTo: profileView.leadingAnchor).isActive = true
           profileUserName.trailingAnchor.constraint(equalTo: profileView.trailingAnchor).isActive = true
           profileUserName.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
           profileUserName.heightAnchor.constraint(equalToConstant: 50).isActive = true
           
           //profileMailAdress
           profileMailAdress.topAnchor.constraint(equalTo: profileUserName.bottomAnchor).isActive = true
           profileMailAdress.leadingAnchor.constraint(equalTo: profileView.leadingAnchor).isActive = true
           profileMailAdress.trailingAnchor.constraint(equalTo: profileView.trailingAnchor).isActive = true
           profileMailAdress.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
           profileMailAdress.heightAnchor.constraint(equalToConstant: 40).isActive = true
       }

    
}
