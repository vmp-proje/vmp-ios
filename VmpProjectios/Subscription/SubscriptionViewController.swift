import Foundation
import UIKit
import Alamofire

class SubscriptionViewController: ViewController<SubscriptionView> {
  
  let searchUrl = URL(string: "https://www.googleapis.com/youtube/v3/search")
  var searchedUrlText: String = String()
  
  override func viewDidLoad() {
    //    execute(url: searchUrl!, query: "Zeynep Bastık")
    customView.setupLayout()
  }
  
  func execute(url: URL, query: String) {
    print("\n\n--------------------------------\n")
    
    Alamofire.request(url,
                      method: HTTPMethod.get,
                      parameters: ["part": "snippet", "q": query, "key": "AIzaSyBQmoRsMPI8t5XibRv-suraDfYnfr0hYZE", "maxResults": 5, "type": "video"]) // değişmeli
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
              let snippet = steps["snippet"] as? [String: Any]
              let thumbnails = snippet!["thumbnails"] as? [String: Any]
              let mediumPhoto = thumbnails!["medium"] as? [String: Any]
              
              print("######")
              print("Url       -> \(self.searchedUrlText)")
              print("Video Id  -> \(videoId!)")
              print("Title     -> \(snippet!["title"] ?? "Hata Title")") //items[0].snippet.title -> steps.snippet.title
              print("Photo Url -> \(mediumPhoto!["url"] ?? "Hata Photo Url")") // items[0].snippet.thumbnails.medium.url -> steps.snippet.thumbnails.medium.url
              print("######")
            }
          }
          
        }
        
        if response.result.isSuccess != true{
          print("Error.")
        }
        
    }
    
  }
  
  
  
  
  
}
