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
  var type: String?
  var attributes: CategoryContentListAttributes?
  var relationships: CategoryContentListRelationships?
  
  init(id: String?, type: String?, attributes: CategoryContentListAttributes?, relationships: CategoryContentListRelationships?) {
    self.id = id
    self.attributes = attributes
    self.attributes = attributes
    self.relationships = relationships
  }
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    type <- map["type"]
    attributes <- map["attributes"]
    relationships <- map["relationships"]
  }
  
}


internal struct CategoryContentListAttributes: Mappable {
  var name : String?
  var content_type : String?
  var multiple : Bool?
  var description : String?
  var tag_list : [String]?
  var image : String?
  var media : String?
  var duration : Int?
  var is_favorited : Bool?
  var section_type : String?
  var is_premium : Bool?
  var is_new : Bool?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    name <- map["name"]
    content_type <- map["content_type"]
    multiple <- map["multiple"]
    description <- map["description"]
    tag_list <- map["tag_list"]
    image <- map["image"]
    media <- map["media"]
    duration <- map["duration"]
    is_favorited <- map["is_favorited"]
    section_type <- map["section_type"]
    is_premium <- map["is_premium"]
    is_new <- map["is_new"]
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
