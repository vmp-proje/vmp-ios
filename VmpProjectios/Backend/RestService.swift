//
//  RestService.swift
//  VmpProjectios
//
//  Created by Anil Joe on 2.05.2020.
//  Copyright © 2020 Metin Yıldız. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import PromiseKit

public protocol HeaderMappable : Mappable {
  
  mutating func headerMapping(_ map: NSDictionary)
}


public protocol RestService {
  
  func url() -> URL
  
  func HTTPHeaders() -> [String: String]
  
  func parameters() -> [String:AnyObject]?
  
  func method()-> HTTPMethod
  
  func parameterEncoding() -> ParameterEncoding
  
  func performRequest<T: Sequence>(_ mapTo: T.Type) -> Promise<T> where T.Iterator.Element : HeaderMappable
  
  func performRequest<T: HeaderMappable>(_ mapTo: T.Type) -> Promise<T>
  
  //TODO func performRequest<T: Mappable>(mapTo: T.Type) -> Promise<T>
  
  func keyPath() -> String?
  
  func performRequest() -> Promise<String>
  
  func errorTranslator(_ error: Error?, response: Data?, httpResponse: HTTPURLResponse?) -> Error?
  
  func retryHandler() -> Bool
  
  var retryCount: Int {get}
}

public enum RestServiceError: Error{
  case unknownError
  case retryRequest
}

public extension RestService{
  public func performRequest<T: Sequence>(_ mapTo: T.Type) -> Promise<T> where T.Iterator.Element : HeaderMappable{
    return performRequest(mapTo, currentRetryCount: 1)
  }
  
  public func performRequest<T: HeaderMappable>(_ mapTo: T.Type) -> Promise<T>{
    return performRequest(mapTo, currentRetryCount: 1)
  }
  
  public func performRequest() -> Promise<String>{
    return performRequest(1)
  }
  
  public func errorTranslator(_ errorType: Error?, response: Data?, httpResponse: HTTPURLResponse?) -> Error?{
    return nil
  }
  
  public func retryHandler() -> Bool {
    return true
  }
  
  public var retryCount :Int {
    return 1
  }
  
  fileprivate func performRequest<T: Sequence>(_ mapTo: T.Type, currentRetryCount: Int) -> Promise<T> where T.Iterator.Element : HeaderMappable{
    if currentRetryCount > retryCount {
      return Promise(error: RestServiceError.unknownError)
    }
    
    return Promise { seal in
      
      self._performRequest().validate().responseArray(completionHandler: { (response : DataResponse<[T.Iterator.Element]>) in
        
        if let error = self.translateError(response){
          seal.reject(error)
        }
        else if let result = response.result.value as? T{
          seal.fulfill(result)
        }
        else {
          seal.reject(RestServiceError.unknownError)
        }
      })
    }
    
  }
  
  fileprivate func performRequest<T: HeaderMappable>(_ mapTo: T.Type, currentRetryCount: Int) -> Promise<T> {
    if currentRetryCount > retryCount {
      return Promise(error: RestServiceError.unknownError)
    }
    
    return Promise<T> { seal in
      
      self._performRequest().validate().responseObject(keyPath: keyPath(), completionHandler: { (response : DataResponse<T>) in
        
        if let error = self.translateError(response){
          seal.reject(error)
        }
        else if let result = response.result.value{
          
          var mutatingResult = result;
          if let headers = response.response?.allHeaderFields {
            mutatingResult.headerMapping(headers as NSDictionary)
          }
          seal.fulfill(mutatingResult)
        }
        else {
          seal.reject(RestServiceError.unknownError)
        }
      })
      
    }
  }
  
  fileprivate func performRequest(_ currentRetryCount: Int) -> Promise<String> {
    if currentRetryCount > retryCount {
      return Promise(error: RestServiceError.unknownError)
    }
    
    return Promise { seal in
      self._performRequest().responseString(completionHandler: { (response) in
        if let error = self.translateError(response){
          seal.reject(error)
        }
        else {
          seal.fulfill(response.result.value ?? "")
        }
      })
    }.recover({ (error) -> Promise<String> in
      if error as? RestServiceError == RestServiceError.retryRequest{
        
        return self.performRequest(currentRetryCount + 1)
        
      }
      else{
        return Promise(error: error)
      }
    })
  }
  
  fileprivate func translateError<T>(_ response: DataResponse<T>) -> Error?{
    if let translatedError = self.errorTranslator(response.result.error,response: response.data, httpResponse: response.response){
      return translatedError
    }
    else {
      print("response.result.error: \(response.result.error)")
      return response.result.error
    }
  }
  
  fileprivate func _performRequest() -> DataRequest {
    let url = self.url()
    let headers = self.HTTPHeaders()
    let parameters = self.parameters()
    let method = self.method()
    let parameterEncoding = self.parameterEncoding()
    
    print(">>>> URL: \(url)")
    print(">>>> Headers:")
//    headers.prettyPrint()
    if let parameters = parameters {
      print(">>>> parameters: \(parameters)")
    }
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    
    return Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers)
      .responseJSON(completionHandler: { (response) in
        if let url = response.request?.url {
          print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
          print("<< URL: \(url)")
        }
        
        if let parameters = parameters {
          print("<< parameters: \(parameters)")
        }
        
        //            if let headers = response.response?.allHeaderFields {
        //                print("<< Headers: \(headers)")
        //            }
        
        if let response = response.result.value, response is NSNull == false,
          let jsonData = try? JSONSerialization.data(withJSONObject: response, options: [JSONSerialization.WritingOptions.prettyPrinted]),
          let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) {
          print("<< \(jsonStr)")
        }
      })
    
  }
  
}

