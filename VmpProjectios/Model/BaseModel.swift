//
//  BaseModel.swift
//  VmpProjectios
//
//  Created by Anil Joe on 10.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import ObjectMapper


class BaseModel: HeaderMappable {

//  var createAt:String?
  
  required init?(map: Map) {}

  init() { }

  func mapping(map: Map){}

  func headerMapping(_ data: NSDictionary) {}
  
}
//
//class  NoModel: HeaderMappable {
//
//  required init?(map: Map) {
//
//  }
//
//  init() {
//
//  }
//
//  func mapping(map: Map)
//  {
//
//  }
//
//  func headerMapping(_ data: NSDictionary) {
//
//  }
//}
//
//public protocol HeaderMappable : Mappable {
//
//  mutating func headerMapping(_ map: NSDictionary)
//}
