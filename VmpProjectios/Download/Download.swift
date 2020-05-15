//
//  Download.swift
//  VmpProjectios
//
//  Created by Anil Joe on 12.04.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation
import Localize_Swift

class Download {
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var content: CategoryContentListData
  var state: DownloadState = .downloading
  
  init(content: CategoryContentListData) {
    self.content = content
  }
}



//struct CategoryContentListData: Mappable {
class CategoryContentListData: BaseModel {
  
  var status : String?
  var attributes: CategoryContentListAttributes?
  
  init(attributes: CategoryContentListAttributes?) {
    super.init()
    self.attributes = attributes
  }
  
  required init?(map: Map) {
    fatalError("init(map:) has not been implemented")
  }
  
  override func mapping(map: Map) {
    super.mapping(map: map)

    status <- map["status"]
    attributes <- map["attributes"]
  }
}


internal struct CategoryContentListAttributes: Mappable {
  var url : String?
  var duration : Int?
  var title : String?
  var thumbnail : String?
  var id : String?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    url <- map["url"]
    duration <- map["duration"]
    title <- map["title"]
    thumbnail <- map["thumbnail"]
    id <- map["id"]
  }
  
}


internal struct CategoryContentListRelationships: Mappable {
//  var user : CategoryContentListUser?
//  var category : Category?
//  var content : CategoryContentListContent?
//  var contents : CategoryContentListContents?
  
//  init(user : CategoryContentListUser?, category : Category?, content : CategoryContentListContent?, contents : CategoryContentListContents?) {
//    self.user = user
//    self.category = category
//    self.content = content
//    self.contents = contents
//  }
  
  init() {
    
  }
  init?(map: Map) {}
//
  mutating func mapping(map: Map) {
//    user <- map["user"]
//    category <- map["category"]
//    content <- map["content"]
//    contents <- map["contents"]
  }
}
