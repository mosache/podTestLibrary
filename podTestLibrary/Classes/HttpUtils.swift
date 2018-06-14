//
//  HttpUtils.swift
//  SwiftP
//
//  Created by 傅强 on 2018/6/13.
//  Copyright © 2018年 yd. All rights reserved.
//

import Foundation
import Moya
import Result

//enum HttpRequestType {
//    case get
//    case post
//}

enum HttpResponseType {
    case string
    case json
}

open class HttpUtils<T:TargetType> {
    typealias SuccessHandler = (Any) -> Void
    typealias FailureHandler = (NSError) -> Void
    
//    var method:HttpRequestType = .get
    var respType : HttpResponseType = .json
    
    var succsessHandler : SuccessHandler?
    var failureHandler : FailureHandler?
    

    
   
}

// 属性设置
extension HttpUtils {
//    func method ( _ method : HttpRequestType) -> Self {
//        self.method = method
//        return self
//    }
    
    func responType ( _ respType : HttpResponseType) -> Self {
        self.respType = respType
        return self
    }
    
    func successHandler ( _ successHandler :@escaping SuccessHandler ) -> Self {
        self.succsessHandler = successHandler
        return self
    }
    
    func failureHandler ( _ failureHandler : @escaping FailureHandler) -> Self {
        self.failureHandler = failureHandler
        return self
    }
    
}

// 请求
extension HttpUtils {
    func request(target: T) -> Void{
        let provider = MoyaProvider<T>()
        provider.request(target) { result in
            switch result {
            case .success(let value):
                if (self.succsessHandler != nil) {
                    if (self.respType == .json) {
                        do {
                            let jsonObj = try JSONSerialization.jsonObject(with: value.data, options: JSONSerialization.ReadingOptions.allowFragments)
                            self.succsessHandler! (jsonObj)
                        }catch {
                            if (self.failureHandler != nil) {
                                self.failureHandler! (error as NSError)
                            }
                        }
                    }else if (self.respType == .string) {
                        let respStr = String.init(data: value.data, encoding: String.Encoding.utf8)
                        self.succsessHandler! (respStr!)
                    }
                }
                break
            case .failure(let error):
                if (self.failureHandler != nil) {
                    self.failureHandler! (error as NSError)
                }
                break
            }
        }
    }
}


open class YD_DataResponse {
    typealias HttpResult = Moya.Response
    typealias JSONRespHandler = (_ json:Dictionary<String,Any>, _ error:Error) -> Void
    var result : HttpResult?
    var error:Error?
    init(result:HttpResult? ,error:Error?) {
        self.result = result
        self.error = error
    }
    
    func jsonResponse( handler: @escaping JSONRespHandler) -> Void {
        
    }
}

