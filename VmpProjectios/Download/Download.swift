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


struct CategoryContentListData: Mappable {
  var id: String?
//  var type: String?
  var attributes: CategoryContentListAttributes?
//  var relationships: CategoryContentListRelationships?
  
  //init(id: String?, type: String?, attributes: CategoryContentListAttributes?, relationships: CategoryContentListRelationships?) {
  init(id: String?, attributes: CategoryContentListAttributes?) {
    self.id = id
//    self.type = type
    self.attributes = attributes
//    self.relationships = relationships
  }
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id <- map["id"]
//    type <- map["type"]
    attributes <- map["attributes"]
//    relationships <- map["relationships"]
  }
  
}


internal struct CategoryContentListAttributes: Mappable {
  var name : String?
  var image : String?
  var description : String?
  var media : String?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    name <- map["name"]
    description <- map["description"]
    image <- map["image"]
    media <- map["media"]
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
