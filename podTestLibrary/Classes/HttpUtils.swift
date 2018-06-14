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

public enum HttpRequestType {
    case get
    case post
}

public enum HttpResponseType {
    case string
    case json
}

public class HttpUtils<T:TargetType> {
    public typealias SuccessHandler = (Any) -> Void
     public typealias FailureHandler = (NSError) -> Void
    
    var method:HttpRequestType = .get
    var respType : HttpResponseType = .json
    
    var succsessHandler : SuccessHandler?
    var failureHandler : FailureHandler?
    
    public init(){}
}

// 属性设置
extension HttpUtils {
   public func method ( _ method : HttpRequestType) -> Self {
        self.method = method
        return self
    }
    
    public func responType ( _ respType : HttpResponseType) -> Self {
        self.respType = respType
        return self
    }
    
    public func successHandler ( _ successHandler :@escaping SuccessHandler ) -> Self {
        self.succsessHandler = successHandler
        return self
    }
    
     public func failureHandler ( _ failureHandler : @escaping FailureHandler) -> Self {
        self.failureHandler = failureHandler
        return self
    }
    
}

// 请求
extension HttpUtils {
    public func request(target: T) -> Void{
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


public class YD_DataResponse {
    public typealias HttpResult = Moya.Response
    public typealias JSONRespHandler = (_ json:Dictionary<String,Any>, _ error:Error) -> Void
    var result : HttpResult?
    var error:Error?
    init(result:HttpResult? ,error:Error?) {
        self.result = result
        self.error = error
    }
    
    public func jsonResponse( handler: @escaping JSONRespHandler) -> Void {
        
    }
}

