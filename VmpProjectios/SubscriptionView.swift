import Foundation
import UIKit

class SubscriptionView: View {

    //MARK: - UI Objects
    
    let navigationBar: UINavigationBar = {
        var navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.tintColor = .white
        navBar.setColors(background: UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1), text: .white)
        var navItem = UINavigationItem(title: "Choose Your Plan")
        var backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    let perAnnualTextTitle: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false

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
    
    let perAnnualTextDescription: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Billed as one 10 USD \npayment every 12 months"
        textView.font = .systemFont(ofSize: 12)
        textView.textColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.textAlignment = .center
        return textView
    }()
    
    let buttonPerAnnual: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose Plan", for: UIControl.State.normal)
        button.titleColorForNormal = .black
        button.tintColor = .black
        button.backgroundColor = .systemYellow
        return button
    }()
    
    let fistLine: UIView = {
        var customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
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
        self.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        
        self.addSubview(navigationBar)
        self.addSubview(perAnnualTextTitle)
        self.addSubview(perAnnualTextDescription)
        self.addSubview(buttonPerAnnual)
        self.addSubview(fistLine)
        
        self.navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.perAnnualTextTitle.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 15).isActive = true
        self.perAnnualTextTitle.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 70).isActive = true
        self.perAnnualTextTitle.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -70).isActive = true
        self.perAnnualTextTitle.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        self.perAnnualTextDescription.topAnchor.constraint(equalTo: self.perAnnualTextTitle.bottomAnchor).isActive = true
        self.perAnnualTextDescription.leadingAnchor.constraint(equalTo: self.perAnnualTextTitle.leadingAnchor).isActive = true
        self.perAnnualTextDescription.trailingAnchor.constraint(equalTo: self.perAnnualTextTitle.trailingAnchor).isActive = true
        self.perAnnualTextDescription.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.buttonPerAnnual.topAnchor.constraint(equalTo: self.perAnnualTextDescription.bottomAnchor, constant: 5).isActive = true
        self.buttonPerAnnual.leadingAnchor.constraint(equalTo: self.perAnnualTextDescription.leadingAnchor).isActive = true
        self.buttonPerAnnual.trailingAnchor.constraint(equalTo: self.perAnnualTextDescription.trailingAnchor).isActive = true
        self.buttonPerAnnual.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.buttonPerAnnual.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.fistLine.topAnchor.constraint(equalTo: self.buttonPerAnnual.bottomAnchor, constant: 35).isActive = true
        self.fistLine.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.fistLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        self.fistLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
}
