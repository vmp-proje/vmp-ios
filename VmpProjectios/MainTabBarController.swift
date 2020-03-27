import UIKit
import ESTabBarController_swift


class MainTabBarController: ESTabBarController, UITabBarControllerDelegate {


  //MARK: - Variables
  var lastSelectedTabIndex: Int?


  //MARK: - SubView Controllers
  let homeVC = HomeViewController()
  let musicVC = MusicViewController()
  let profileVC = ProfileViewController()


  //MARK: - Visual Objects
  /// Used to cover Main Tab Bar & Music Player's behind.
  let tabBarBottomContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.appDarkBackground

    return view
  }()


  //MARK: - View Appareance
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear

    layoutBottomContainerView()
    setupTabBar()
    setupNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  //MARK: - Dark Mode
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
  }



  //MARK: - UI
  @objc func hideBottomContainerView() {
    UIView.animate(withDuration: 0.45, animations: {
      self.tabBarBottomContainerView.alpha = 0
    }) { done in
      self.tabBarBottomContainerView.isHidden = true
    }
  }

  @objc func showBottomContainerView() {
    tabBarBottomContainerView.isHidden = false
    UIView.animate(withDuration: 0.45, animations: {
      self.tabBarBottomContainerView.alpha = 1
    })
  }

  private func layoutBottomContainerView() {
    tabBarBottomContainerView.isHidden = true
    view.addSubview(tabBarBottomContainerView)
    tabBarBottomContainerView.autoPinEdge(.bottom, to: .bottom, of: view)
    tabBarBottomContainerView.autoPinEdge(.right, to: .right, of: view)
    tabBarBottomContainerView.autoPinEdge(.left, to: .left, of: view)
    tabBarBottomContainerView.autoSetDimension(.height, toSize: 120)
  }

  private func setupTabBar() {
    tabBar.layer.masksToBounds = true
    tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    UITabBar.appearance().barTintColor = UIColor.darkTabBar
    UITabBar.appearance().cornerRadius = 29

    let contentView = IrregularityContentView()
    contentView.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    contentView.imageView.layer.cornerRadius = 35
    contentView.imageView.layer.borderWidth = 3
    contentView.imageView.layer.borderColor = UIColor.init(red: 20/255.0, green: 24/255.0, blue: 41/255.0, alpha: 1.0).cgColor
    contentView.imageView.backgroundColor = UIColor.init(red: 7/255.0, green: 11/255.0, blue: 29/255.0, alpha: 1.0)

    homeVC.tabBarItem = ESTabBarItem.init(IrregularityContentView(), title: "Home".localized(), image: UIImage(named: "home_icon")!.withRenderingMode(.alwaysTemplate), selectedImage: nil)
    musicVC.tabBarItem = ESTabBarItem.init(IrregularityContentView(), title: "Music".localized(), image: UIImage(named: "music_icon")!.withRenderingMode(.alwaysTemplate), selectedImage: nil)
    profileVC.tabBarItem = ESTabBarItem.init(IrregularityContentView(), title: "Profile".localized(), image: UIImage(named: "profile_icon")!.withRenderingMode(.alwaysTemplate), selectedImage: nil)

    viewControllers = [homeVC, musicVC, profileVC]
    self.delegate = self
  }

  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//    if tabBarController.selectedIndex == lastSelectedTabIndex { // tapped to the same tab
//      if lastSelectedTabIndex == 0 {
//        homeVC.scrollToTheTop()
//      } else if lastSelectedTabIndex == 1 {
//        meditationVC.scrollToTheTop()
//      } else if lastSelectedTabIndex == 3 {
//        musicVC.scrollToTheTop()
//      } else {
//        sleepVC.scrollToTheTop()
//      }
//
//    } else { //Switched tabs
//    }
//    lastSelectedTabIndex = tabBarController.selectedIndex
  }

  //MARK: Show - Hide TabBar Animations
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
  }
}
