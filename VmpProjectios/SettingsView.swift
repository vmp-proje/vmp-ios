import UIKit

class SettingsView: View, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Visual Objects
    
    let userInformationView: UIView = {
        var customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .green
        return customView
    }()
    
    let userPhoto: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profile_photo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60 / 2.0
        return imageView
    }()
    
    let userNameAndMailView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    let userName: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .boldSystemFont(ofSize: 15)
        return textView
    }()
    
    let userMailAdress: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .lightText
        return textView
    }()
    
    let manageGoogleAccountButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .blue
        button.setTitle("Manage your Google Account", for: UIControl.State.normal)
        return button
    }()
    
    let labelSettings: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Youtube Premium".localizedUppercase
        label.backgroundColor = .darkGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()

    let customTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let cellNameArray = ["Downloads", "History", "Get Premium", "Support", "Privacy Policy", "Terms Of Use", "Logout"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        customTableView.delegate = self
        customTableView.dataSource = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNameArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cellNameArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        return cell
    }
    
    //MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tıklandı.")
    }
    
    //MARK: - UI Layout
    
    func customTableViewLayout() {
        addSubview(userInformationView)
        addSubview(labelSettings)
        addSubview(customTableView)
        
        setupUserInformationView()
        setupLabelSettingLayout()
        setupCustomTableViewLayout()
    }
    
    func setupUserInformationView() {
        userInformationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        userInformationView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        userInformationView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        userInformationView.bottomAnchor.constraint(equalTo: labelSettings.topAnchor).isActive = true
        userInformationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
//        setupInsideOfUserInformationView()
        //User Photo
        userInformationView.addSubview(userPhoto)
        
        userPhoto.topAnchor.constraint(equalTo: userInformationView.topAnchor, constant: 10).isActive = true
        userPhoto.leadingAnchor.constraint(equalTo: userInformationView.leadingAnchor, constant: 15).isActive = true
        userPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userPhoto.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        // User Name and Mail
        userInformationView.addSubview(userNameAndMailView)
//        userInformationView.addSubview(manageGoogleAccountButton)
        
        userNameAndMailView.topAnchor.constraint(equalTo: userInformationView.topAnchor, constant: 10).isActive = true
        userNameAndMailView.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: 10).isActive = true
        userNameAndMailView.trailingAnchor.constraint(equalTo: userInformationView.trailingAnchor, constant: -10).isActive = true
        userNameAndMailView.bottomAnchor.constraint(equalTo: userInformationView.bottomAnchor, constant: -30).isActive = true // Change with ManageGoogleAccountButton
//        userNameAndMailView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    func setupInsideOfUserInformationView() {
       
        userPhoto.topAnchor.constraint(equalTo: userInformationView.topAnchor).isActive = true
        userPhoto.leadingAnchor.constraint(equalTo: userInformationView.leadingAnchor).isActive = true
        userPhoto.trailingAnchor.constraint(equalTo: userInformationView.leadingAnchor).isActive = true
        userPhoto.topAnchor.constraint(equalTo: userInformationView.topAnchor).isActive = true
        userPhoto.heightAnchor.constraint(equalToConstant: 60).isActive = true // Maybe constant 50
        
        setupuserNameAndMailView()
    }
    
    func setupuserNameAndMailView() {
        
        userInformationView.addSubview(userNameAndMailView) // IMPORTANT
        
        userNameAndMailView.topAnchor.constraint(equalTo: userInformationView.topAnchor).isActive = true
        userNameAndMailView.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor).isActive = true
        userNameAndMailView.trailingAnchor.constraint(equalTo: userInformationView.trailingAnchor).isActive = true
        userNameAndMailView.bottomAnchor.constraint(equalTo: manageGoogleAccountButton.topAnchor).isActive = true
        userNameAndMailView.heightAnchor.constraint(equalToConstant: 50).isActive = true // Maybe constant 50
    }
    
    func setupManageAccountButtonLayout() {
//        manageGoogleAccountButton.topAnchor
    }
    
    func setupLabelSettingLayout() {
        labelSettings.topAnchor.constraint(equalTo: userInformationView.bottomAnchor).isActive = true
        labelSettings.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        labelSettings.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        labelSettings.bottomAnchor.constraint(equalTo: customTableView.topAnchor).isActive = true
        labelSettings.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupCustomTableViewLayout() {
        customTableView.topAnchor.constraint(equalTo: labelSettings.bottomAnchor).isActive = true
        customTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        customTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        customTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}
