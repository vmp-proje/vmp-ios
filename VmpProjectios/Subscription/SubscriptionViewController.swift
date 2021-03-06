import Foundation
import UIKit
import Alamofire

class SubscriptionViewController: ViewController<SubscriptionView> {
  
  let searchUrl = URL(string: "https://www.googleapis.com/youtube/v3/search")
  var searchedUrlText: String = String()
  let youtube_access_token = "AIzaSyDTc8XIi1hjiY0pEyEm6hBLcDKw6VVXC8M"
    
  override func viewDidLoad() {
//    print("Execute Çalışacak")
//    execute(url: searchUrl!, query: "Zeynep Bastık")
    customView.setupLayout()
  }
  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  override func viewDidAppear(_ animated: Bool) {
    setupNavBar()
  }
  @objc func dismissVC() {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  private func setupNavBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    
    navigationItem.title = "Choose Your Plan".localized()
    
    let backButton = UIButton(type: UIButton.ButtonType.custom)
    backButton.setTitleColor(.black, for: .normal)
    let arrowImg = UIImage(named: "left_arrow")?.withRenderingMode(.alwaysTemplate)
    backButton.setImage(arrowImg, for: .normal)
    backButton.imageView?.tintColor = Color.appWhite
    backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    let backBarButton = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = backBarButton
  }
  
  
//  func execute(url: URL, query: String) {
//    print("\n\n--------------------------------\n")
//
//    Alamofire.request(url,
//                      method: HTTPMethod.get,
//
//                      parameters: ["part": "snippet", "q": query, "key": youtube_access_token, "maxResults": 6, "type":"video"])
//
//      .validate()
//      .responseJSON { (response) in
//        switch response.result {
//        case .success:
//            if let value = response.result.value as? [String: Any] {
//              if let items = value["items"] as? [[String: Any]] {
//                for steps in items {
//
//                  let propertyId = steps["id"] as? [String: Any]
//                  let videoId = propertyId!["videoId"]
//                  print("Url: \(self.searchedUrlText)")
//                  let videoIdUrlPart = "?v=\(videoId!)"
//                  self.searchedUrlText = "https://www.youtube.com/watch\(videoIdUrlPart)"
//                  let snippet = steps["snippet"] as? [String: Any]
//                  let thumbnails = snippet!["thumbnails"] as? [String: Any]
//                  let mediumPhoto = thumbnails!["medium"] as? [String: Any]
//
//                  print("######")
//                  print("Url       -> \(self.searchedUrlText)")
//                  print("Video Id  -> \(videoId!)")
//                  print("Title     -> \(snippet!["title"] ?? "Hata Title")")
//                  print("Photo Url -> \(mediumPhoto!["url"] ?? "Hata Photo Url")")
//                  print("######")
//                }
//              } else {
//                    print("İtem diye bir veri yok.")
//                }
//
//            }
//        case .failure(let error):
//            print("!!!!!!Error: \(error)")
//        }
//    }
//  }
  
  
  
  
  
}
