//
//  PopularVideos.swift
//  VmpProjectios
//
//  Created by Anil Joe on 10.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import Localize_Swift


//MARK: Items
//struct PopularVideos : Mappable {
//  var kind : String?
//  var etag : String?
//  var items : [Items]?
//  var nextPageToken : String?
//  var pageInfo : PageInfo?
//
//  init?(map: Map) {
//
//  }
//
//  mutating func mapping(map: Map) {
//    kind <- map["kind"]
//    etag <- map["etag"]
//    items <- map["items"]
//    nextPageToken <- map["nextPageToken"]
//    pageInfo <- map["pageInfo"]
//  }
//
//}
class SearchVideos: BaseModel {
  var kind : String?
  var etag : String?
  var items : [MostPopularItems]?
  var nextPageToken : String?
  var pageInfo : PageInfo?

  override func mapping(map: Map) {
    super.mapping(map: map)

    kind <- map["kind"]
    etag <- map["etag"]
    items <- map["items"]
    nextPageToken <- map["nextPageToken"]
    pageInfo <- map["pageInfo"]
  }
}


class PopularVideos: BaseModel {
  var kind : String?
  var etag : String?
  var items : [Items]?
  var nextPageToken : String?
  var pageInfo : PageInfo?

  override func mapping(map: Map) {
    super.mapping(map: map)

    kind <- map["kind"]
    etag <- map["etag"]
    items <- map["items"]
    nextPageToken <- map["nextPageToken"]
    pageInfo <- map["pageInfo"]
  }
}




//MARK: Items
struct MostPopularItems : Mappable {
  var kind : String?
  var etag : String?
  var id : Id?
  var snippet : Snippet?

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {

    kind <- map["kind"]
    etag <- map["etag"]
    id <- map["id"]
    snippet <- map["snippet"]
  }

}

struct Items : Mappable {
  var kind : String?
  var etag : String?
  var id : String?
  var snippet : Snippet?

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {

    kind <- map["kind"]
    etag <- map["etag"]
    id <- map["id"]
    snippet <- map["snippet"]
  }

}



//MARK: Id
struct Id : Mappable {
  var kind : String?
  var videoId : String?

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {

    kind <- map["kind"]
    videoId <- map["videoId"]
  }

}



//MARK: Thumbnails
struct Thumbnails : Mappable {
  var defaultQuality : DefaultQuality?
  var medium : Medium?
  var high : High?
  var standard : Standard?
  var maxres : Maxres?

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {

    defaultQuality <- map["defaultQuality"]
    medium <- map["medium"]
    high <- map["high"]
    standard <- map["standard"]
    maxres <- map["maxres"]
  }

}



//MARK: Maxres
struct Maxres : Mappable {
  var url : String?
  var width : Int?
  var height : Int?

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {

    url <- map["url"]
    width <- map["width"]
    height <- map["height"]
  }

}


//MARK: Standard
struct Standard : Mappable {
  var url : String?
  var width : Int?
  var height : Int?

  init?(map: Map) {

  }

  mutating func mapping(map: Map) {

    url <- map["url"]
    width <- map["width"]
    height <- map["height"]
  }

}


//MARK: High
struct High : Mappable {
  var url : String?
  var width : Int?
  var height : Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    url <- map["url"]
    width <- map["width"]
    height <- map["height"]
  }
  
}


//MARK: Default
struct DefaultQuality : Mappable {
  var url : String?
  var width : Int?
  var height : Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    url <- map["url"]
    width <- map["width"]
    height <- map["height"]
  }
  
}

//MARK: Medium
struct Medium : Mappable {
  var url : String?
  var width : Int?
  var height : Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    url <- map["url"]
    width <- map["width"]
    height <- map["height"]
  }
  
}



//MARK: Localized
struct Localized : Mappable {
  var title : String?
  var description : String?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    title <- map["title"]
    description <- map["description"]
  }
  
}



//MARK: Snippet
struct Snippet : Mappable {
  var publishedAt : String?
  var channelId : String?
  var title : String?
  var description : String?
  var thumbnails : Thumbnails?
  var channelTitle : String?
  var tags : [String]?
  var categoryId : String?
  var liveBroadcastContent : String?
  var localized : Localized?
  var defaultAudioLanguage : String?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    publishedAt <- map["publishedAt"]
    channelId <- map["channelId"]
    title <- map["title"]
    description <- map["description"]
    thumbnails <- map["thumbnails"]
    channelTitle <- map["channelTitle"]
    tags <- map["tags"]
    categoryId <- map["categoryId"]
    liveBroadcastContent <- map["liveBroadcastContent"]
    localized <- map["localized"]
    defaultAudioLanguage <- map["defaultAudioLanguage"]
  }
  
}


//MARK: Snippet
struct PageInfo : Mappable {
  var totalResults : Int?
  var resultsPerPage : Int?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    totalResults <- map["totalResults"]
    resultsPerPage <- map["resultsPerPage"]
  }
  
}
