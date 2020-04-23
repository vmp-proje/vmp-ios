import Foundation
import UIKit
import Alamofire

class SubscriptionViewController: ViewController<SubscriptionView> {
    
    let searchUrl = URL(string: "https://www.googleapis.com/youtube/v3/search")
    var searchedUrlText: String = String()
    
    override func viewDidLoad() {
        execute(url: searchUrl!)
    }
    
    func execute(url: URL) {
        print("\n\n--------------------------------\n")
        let searchUrl = URL(string: "https://www.googleapis.com/youtube/v3/search")

        Alamofire.request(searchUrl!,
                          method: HTTPMethod.get,
                          parameters: ["part": "snippet", "q": "Zeynep Bastık", "key": "AIzaSyDCx26FQV1ZTR5Y6oLGdE2KeQd8on5bVE8", "maxResults": 5, "type": "video"])
        .validate()
            .responseJSON { (response) in
                // items -> [0] -> id -> videoId
                if let value = response.result.value as? [String: Any] {
                    
                    if let items = value["items"] as? [[String: Any]] {
                        for steps in items {
                            let propertyId = steps["id"] as? [String: Any]
                            let videoId = propertyId!["videoId"]
                            let videoIdUrlPart = "?v=\(videoId!)"
                            self.searchedUrlText = "https://www.youtube.com/watch\(videoIdUrlPart)"
                            print(self.searchedUrlText)
                        }
                    }
                    
                }
                
                if response.result.isSuccess != true{
                    print("Error.")
                }

        }
        
    }
    
    

    
    
}
