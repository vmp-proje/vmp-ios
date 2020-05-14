import UIKit
import ESTabBarController_swift

class MainTabBarController: ESTabBarController, UITabBarControllerDelegate {


  //MARK: - Variables
  
  var lastSelectedTabIndex: Int?
  let musicPlayerVC = BaseMusicPlayerViewController()
//  var musicPlayerVC: {
//    return MusicPlayerViewController.shared
//  }


  //MARK: - SubView Controllers
  let homeVC = HomeViewController()
  let musicVC = MusicViewController()
  let profileVC = ProfileViewController()

  var popupBarPlayButton = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(playButtonTapped))
  let playButton = PopupBarPlayButton(frame: .zero)

  @objc func playButtonTapped() {}
  
  //MARK: - Visual Objects
  /// Used to cover Main Tab Bar & Music Player's behind.
  let tabBarBottomContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.appDarkBackground

    return view
  }()


  
  //MARK: - View Appareance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear

    layoutBottomContainerView()
    setupTabBar()
    setupNavigationBar()
    
//    musicPlayerVC.dismissdelegat
  }


  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    let testVC = TestFlowCollectionViewController()
//    self.navigationController?.pushViewController(testVC, animated: true)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      if let playableClass = CategoryContentListAttributes(JSON: ["name" : "",
      "content_type": "",
      "multiple": false,
      "description": "",
      "tag_list": "",
      "image": "",
      "media": "",
      "duration": 0,
      "is_favorited": false,
      "section_type": "",
      "is_premium": true,
      "is_new" : false]) {
      CategoryContentListData(id: "1", type: nil, attributes: playableClass, relationships: nil)
      self.presentPlayerPopupBar()
      }
    }
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
//    UITabBar.appearance().cornerRadius = 

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

  
  //MARK: - Music Player Popup
  @objc func presentPlayerPopupBar() {
      ///Not: CourseDetailsViewController ekraninda navigationController?. ile gosterince bu kod ise yarar hale geldi.
      navigationController?.popupBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      popupBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      showBottomContainerView()
      
  //    presentPopupBar(withContentViewController: musicPlayerVC, animated: true, completion: nil)
      self.playButton.contentId = AudioPlayer.shared.currentTrack?.id
      self.playButton.playButton.updateButtonUI()
      presentPopupBar(withContentViewController: musicPlayerVC, animated: true) { }
      self.view.bringSubviewToFront(self.tabBar)
      
      
  
      
  //    let playButton = PopupBarPlayButton(frame: .zero)
      self.popupBarPlayButton = UIBarButtonItem(customView: self.playButton)
      self.musicPlayerVC.popupItem.rightBarButtonItems = [self.popupBarPlayButton]
      
      if let superView = self.playButton.superview {
        self.playButton.autoPinEdge(.right, to: .right, of: superView, withOffset: -2)
      }
      self.playButton.anchorCenterYToSuperview()
      self.playButton.autoSetDimension(.height, toSize: 46) //34
      self.playButton.autoSetDimension(.width, toSize: 46+5)
      
  //    popupBarPlayButton.addTargetForAction(self, action: #selector(playButtonTapped))
  //    playButton.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

      
      LNPopupCloseButton.appearance().isHidden = false
      LNPopupCloseButton.appearance().alpha = 0.02
      popupContentView.popupCloseButtonStyle = .round

      
      //Update Play Button's icon
      DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
        self.updatePlayButtonIcon()
      }
      
      popupBar.isHidden = false
    }
  
  @objc func updatePlayButtonIcon() {
    //FIXME: - geri ekle
//    if audioPlayer.isPlaying() == true { // Playing
//      self.popupBarPlayButton.image = UIImage(named: "pause-small")!.withRenderingMode(.alwaysTemplate)
//    } else { // Paused
//      self.popupBarPlayButton.image = UIImage(named: "player-play-small")!.withRenderingMode(.alwaysTemplate)
//    }
  }
  
  
  //MARK: - Show&Hide TabBar Animations
  @objc func showSearchViewController() {
    let globalSearchVC = GlobalSearchViewController()
//    globalSearchVC.modalPresentationStyle = .fullScreen
    let nav = UINavigationController(rootViewController: globalSearchVC)
    //nav.modalPresentationStyle = .fullScreen
    nav.modalPresentationStyle = .overCurrentContext
    navigationController?.present(nav, animated: true, completion: nil)
  }
  
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    let globalSearchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
    globalSearchButton.setImage(UIImage(named: "global_search_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
    globalSearchButton.tintColor = Color.appWhite
    globalSearchButton.imageView?.contentMode = .scaleAspectFit
    globalSearchButton.addTarget(self, action: #selector(showSearchViewController), for: .touchUpInside)
    globalSearchButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 0)
    let globalBarButton = UIBarButtonItem(customView: globalSearchButton)
    navigationItem.rightBarButtonItem = globalBarButton
    
  }
}
