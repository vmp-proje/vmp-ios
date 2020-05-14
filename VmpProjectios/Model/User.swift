//
//  User.swift
//  VmpProjectios
//
//  Created by Anil Joe on 14.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import Localize_Swift


class RegisterModel: BaseModel {
  
  var status : String?
  var data : TokenData?

  
  override func mapping(map: Map) {
    super.mapping(map: map)
    
    self.status <- map["status"]
    self.data <- map["data"]
  }
  
}


struct TokenData : Mappable {
  var token : String?
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    
    token <- map["token"]
  }
  
}
