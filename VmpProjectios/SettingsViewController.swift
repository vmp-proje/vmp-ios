import UIKit

class SettingsViewController: ViewController<SettingsView> {

    override func viewDidLoad() {
        print("SettingsVC çalıştı.")
        self.customView.customTableViewLayout()
    }
    
    
}
