//
//  ViewController.swift
//  Vmp
//
//  Created by Metin Yıldız on 10.03.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//
import NVActivityIndicatorView
import PureLayout
import ESTabBarController_swift

class ViewController<V: View>: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
  override func loadView() {
    view = V()
  }
  
  var customView: V {
    return view as! V
  }
  
  
  //MARK: - View Appereance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    if #available(iOS 13.0, *) {
      if traitCollection.userInterfaceStyle == .light {
        return .darkContent
      } else {
        return .lightContent
      }
    } else {
      return .lightContent
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.delegate = self
    
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  
  //MARK: - UpgradeViewController
  
  func scrollToTheTop() { }
  
  //MARK: - Loading Animations
  @objc func startLoadingAnimation() {
    self.startAnimating(CGSize(width: 70, height: 70), message: nil, messageFont: nil, type: .circleStrokeSpin, color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil, fadeInAnimation: nil)
  }
  
  @objc func stopLoadingAnimation() {
    self.stopAnimating()
  }
  
  
  /// ViewController's show alert
  func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "OK".localizedUppercase, style: .default, handler: { (action) in
      completion?()
    }))
    
    present(alertController, animated: true, completion: nil)
  }
  

  //MARK: - Music Player
  let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    
    return view
  }()
  
  private func setupContainerView() {
    customView.addSubview(containerView)
    containerView.fillToSuperview()
  }
  
  
  //MARK: - Dark Mode
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
  }
  
  
  //MARK: - Tab Bar
  func hideTabBar() {
    if var tabFrame = self.tabBarController?.tabBar.frame {
      tabFrame.origin.y = self.customView.frame.size.height + tabFrame.size.height
      UIView.animate(withDuration: 0.5, animations: {
        self.tabBarController?.tabBar.frame = tabFrame
      })
    }
  }
  
  @objc func showTabBar() {
    //Present Player Popup Bar from MainTabBar
    
    //Show Tab Bar
    if var tabFrame = self.tabBarController?.tabBar.frame {
      tabFrame.origin.y = self.customView.frame.size.height - tabFrame.size.height
      UIView.animate(withDuration: 0.5, animations: {
        self.tabBarController?.tabBar.frame = tabFrame
      })
    }
  }
  
}
