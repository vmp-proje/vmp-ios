import UIKit
import SafariServices

protocol SettingsProtocol {
  func showPolicy()
  func showTermsOfUse()
  func getPremium()
}
class ProfileViewController: ViewController<ProfileView>, SettingsProtocol{
  
  func getPremium() {
    let vc = SubscriptionViewController()
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true)
  }
  
  func showPolicy() {
    let vc = SFSafariViewController(url: URL(string: "https://twitter.com/en/privacy")!)
    present(vc, animated: true)
  }
  func showTermsOfUse() {
    let vc = SFSafariViewController(url: URL(string: "https://twitter.com/en/tos")!)
    present(vc, animated: true)
  }
  
  //MARK: - View Appearance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.customView.profileLayoutView()
    customView.delegate = self
  }
  
  
}
