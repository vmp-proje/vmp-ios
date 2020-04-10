import Foundation
import UIKit

class SubscriptionView: View {

    //MARK: - UI Objects
    
    let navigationBar: UINavigationBar = {
        var navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.tintColor = .white
        navBar.setColors(background: UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1), text: .white)
        var navItem = UINavigationItem(title: "Choose Your Plan")
        var backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    let perMonthTextTitle: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Annual Pro"

        var normalAttributed = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        var boldAttributed = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
        let myString = NSMutableAttributedString(string: "Annual Pro\n", attributes: normalAttributed)
        let boldAttributedString = NSAttributedString(string: "0.83 USD", attributes: boldAttributed)
        let normalAttriburtedString = NSAttributedString(string: " / month", attributes: normalAttributed)

        myString.append(boldAttributedString)
        myString.append(normalAttriburtedString)
        textView.attributedText = myString
        
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.textAlignment = .center
        return textView
    }()
    
    let perMonthTextDescription: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let buttonPerMonth: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let fistLine: UIView = {
        var customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    let threeMonthTextTitle: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let threeMonthTextDescription: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let buttonThreeMonth: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let secondLine: UIView = {
        var customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    func setupLayout() {
        self.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
        
        self.addSubview(navigationBar)
        self.addSubview(perMonthTextTitle)
        
        self.navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.perMonthTextTitle.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 15).isActive = true
        self.perMonthTextTitle.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.perMonthTextTitle.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.perMonthTextTitle.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.perMonthTextTitle.widthAnchor.constraint(equalToConstant: self.frame.size.width).isActive = true
    }
    
}
