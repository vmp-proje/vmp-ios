import UIKit

class ProfileViewController: ViewController<ProfileView> {
  
  
  //MARK: - View Appearance
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.customView.profileLayoutView()
  }
  
  
}
