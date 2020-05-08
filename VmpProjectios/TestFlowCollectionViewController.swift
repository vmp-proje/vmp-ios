import UIKit

class TestFlowCollectionViewController: ViewController<FlowCollectionView> {
    
    var urlTexts = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.urlTexts.reserveCapacity(25)
        NotificationCenter.default.addObserver(self, selector: #selector(getUrlTexts(notification:)), name: NSNotification.Name(rawValue: "fetchStandartPhotoUrl"), object: nil)
    }
    
    override func viewDidLoad() {
        self.customView.setupCollectionView()
    }
    
    @objc func getUrlTexts(notification: Notification) {
        self.urlTexts = notification.object as! [String]
        InsiderCollectionView.imageUrlTexts = urlTexts
        var i = 0
        for url in urlTexts {
            i += 1
            print("\(i). Url -> \(url)")
        }
    }
}
