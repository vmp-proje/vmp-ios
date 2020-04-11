import Foundation
import UIKit

class SubscriptionView: View {

    //MARK: - UI Objects
    
    let scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
        button.backgroundColor = .systemYellow
        return button
    }()
    
    let firstLine: UIView = {
        var customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        return customView
    }()
    
    let threeMonthTextTitle: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false

        var normalAttributed = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        var boldAttributed = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
        let myString = NSMutableAttributedString(string: "3 Months Pro\n", attributes: normalAttributed)
        let boldAttributedString = NSAttributedString(string: "3.33 USD", attributes: boldAttributed)
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
    
    let threeMonthTextDescription: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Billed as one 10 USD \npayment every 3 months"
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
    
    let buttonThreeMonth: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose Plan", for: UIControl.State.normal)
        button.backgroundColor = .clear
        button.borderWidth = 0.5
        button.borderColor = .systemYellow
        button.titleColorForNormal = .systemYellow
        return button
    }()
    
    
    let secondLine: UIView = {
        var customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
        return customView
    }()
    
    let termsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Terms", for: UIControl.State.normal)
        button.titleColorForNormal = .systemYellow
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    let privacyButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Privacy", for: UIControl.State.normal)
        button.titleColorForNormal = .systemYellow
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    let recoverPurchaseButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Recovery Purchase", for: UIControl.State.normal)
        button.titleColorForNormal = .systemYellow
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    
    let stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.backgroundColor = .red
        stackView.tintColor = .red
        return stackView
    }()
    
    let longFinalText: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis mi lacinia, condimentum neque eu, sodales odio. Ut et erat luctus, eleifend ligula eu, auctor nisi. In interdum sem id risus fermentum rhoncus. Quisque ultrices molestie vestibulum. Ut id diam quam. Phasellus sed mauris turpis. Nullam urna ex, pulvinar non tortor et, dictum mattis magna. Vivamus eu nisi finibus, ornare dolor luctus, viverra sem. Pellentesque nec nibh quis metus elementum varius vitae ac massa. Duis molestie turpis nec felis feugiat, non laoreet enim consectetur.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis mi lacinia, condimentum neque eu, sodales odio. Ut et erat luctus, eleifend ligula eu, auctor nisi. In interdum sem id risus fermentum rhoncus. Quisque ultrices molestie vestibulum. Ut id diam quam. Phasellus sed mauris turpis. Nullam urna ex, pulvinar non tortor et, dictum mattis magna. Vivamus eu nisi finibus, ornare dolor luctus, viverra sem. Pellentesque nec nibh quis metus elementum varius vitae ac massa. Duis molestie turpis nec felis feugiat, non laoreet enim consectetur.\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis mi lacinia, condimentum neque eu, sodales odio. Ut et erat luctus, eleifend ligula eu, auctor nisi. In interdum sem id risus fermentum rhoncus. Quisque ultrices molestie vestibulum. Ut id diam quam. Phasellus sed mauris turpis. Nullam urna ex, pulvinar non tortor et, dictum mattis magna. Vivamus eu nisi finibus, ornare dolor luctus, viverra sem. Pellentesque nec nibh quis metus elementum varius vitae ac massa. Duis molestie turpis nec felis feugiat, non laoreet enim consectetur."
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
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getScreenWith() -> CGFloat {
        print("Width -> \(screenSize.width)")
        return screenSize.width
    }
    
    func getScreenHeight() -> CGFloat{
        print("Height -> \(screenSize.height)")
        return screenSize.height
    }
    //MARK: - Layout
    
    func setupLayout() {
        self.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.contentSize = CGSize(width: 414.0, height: 1200.0)
        
        self.addSubview(navigationBar)
        self.addSubview(scrollView)
        
        scrollView.addSubview(perAnnualTextTitle)
        scrollView.addSubview(perAnnualTextDescription)
        scrollView.addSubview(buttonPerAnnual)
        scrollView.addSubview(firstLine)
        scrollView.addSubview(threeMonthTextTitle)
        scrollView.addSubview(threeMonthTextDescription)
        scrollView.addSubview(buttonThreeMonth)
        scrollView.addSubview(secondLine)
        scrollView.addSubview(stackView)
        scrollView.addSubview(longFinalText)
        
        self.navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.navigationBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.navigationBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.perAnnualTextTitle.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 15).isActive = true
        self.perAnnualTextTitle.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 70).isActive = true
        self.perAnnualTextTitle.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -70).isActive = true
        self.perAnnualTextTitle.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        self.perAnnualTextDescription.topAnchor.constraint(equalTo: self.perAnnualTextTitle.bottomAnchor).isActive = true
        self.perAnnualTextDescription.leadingAnchor.constraint(equalTo: self.perAnnualTextTitle.leadingAnchor).isActive = true
        self.perAnnualTextDescription.trailingAnchor.constraint(equalTo: self.perAnnualTextTitle.trailingAnchor).isActive = true
        self.perAnnualTextDescription.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.buttonPerAnnual.topAnchor.constraint(equalTo: self.perAnnualTextDescription.bottomAnchor, constant: 5).isActive = true
        self.buttonPerAnnual.leadingAnchor.constraint(equalTo: self.perAnnualTextDescription.leadingAnchor).isActive = true
        self.buttonPerAnnual.trailingAnchor.constraint(equalTo: self.perAnnualTextDescription.trailingAnchor).isActive = true
        self.buttonPerAnnual.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.firstLine.topAnchor.constraint(equalTo: self.buttonPerAnnual.bottomAnchor, constant: 35).isActive = true
        self.firstLine.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10).isActive = true
        self.firstLine.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -10).isActive = true
        self.firstLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.threeMonthTextTitle.topAnchor.constraint(equalTo: self.firstLine.bottomAnchor, constant: 35).isActive = true
        self.threeMonthTextTitle.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 70).isActive = true
        self.threeMonthTextTitle.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -70).isActive = true
        self.threeMonthTextTitle.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        self.threeMonthTextDescription.topAnchor.constraint(equalTo: self.threeMonthTextTitle.bottomAnchor).isActive = true
        self.threeMonthTextDescription.leadingAnchor.constraint(equalTo: self.threeMonthTextTitle.leadingAnchor).isActive = true
        self.threeMonthTextDescription.trailingAnchor.constraint(equalTo: self.threeMonthTextTitle.trailingAnchor).isActive = true
        self.threeMonthTextDescription.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        self.buttonThreeMonth.topAnchor.constraint(equalTo: self.threeMonthTextDescription.bottomAnchor, constant: 5).isActive = true
        self.buttonThreeMonth.leadingAnchor.constraint(equalTo: self.threeMonthTextDescription.leadingAnchor).isActive = true
        self.buttonThreeMonth.trailingAnchor.constraint(equalTo: self.threeMonthTextDescription.trailingAnchor).isActive = true
        self.buttonThreeMonth.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.secondLine.topAnchor.constraint(equalTo: self.buttonThreeMonth.bottomAnchor, constant: 35).isActive = true
        self.secondLine.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10).isActive = true
        self.secondLine.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -10).isActive = true
        self.secondLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        stackView.addArrangedSubview(termsButton)
        stackView.addArrangedSubview(privacyButton)
        stackView.addArrangedSubview(recoverPurchaseButton)
        
        self.stackView.topAnchor.constraint(equalTo: self.secondLine.bottomAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 70).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -70).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.longFinalText.topAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
        self.longFinalText.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.longFinalText.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.longFinalText.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.longFinalText.widthAnchor.constraint(equalToConstant: getScreenWith()).isActive = true
    }
    
}
