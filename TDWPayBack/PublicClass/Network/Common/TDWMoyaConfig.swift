//
//  TDWMoyaConfig.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Result
import TDWKit

/// 测试地址
let URL_test = ""
let H5URL_test = ""

/// 预发布地址
let URL_preProduction = ""
let H5URL_preProduction = ""

/// 发布地址
let URL_production = ""
let H5URL_production = ""

//定义URL通用路径
let commonPath = ""

/// 网络请求API域名
let TDWBaseURL: String = { () -> String in
    switch appEnvironment {
    case .test:
        return URL_test
    case .preProduction:
        return URL_preProduction
    case .production:
        return URL_production
    }
}()
/// 活动域名
let TDWBaseH5URL: String = { () -> String in
    switch appEnvironment {
    case .test:
        return H5URL_test
    case .preProduction:
        return H5URL_preProduction
    case .production:
        return H5URL_production
    }
}()

/// TargetType prtotocol public implement, this can make optional protocol function.
extension TargetType {
    
    public var baseURL: URL {
        
        // 拼接通用路径
        return URL(string: TDWBaseURL)!.appendingPathComponent(commonPath)
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public var task: Task {
        return .request
    }
    
    public var sampleData: Data {
        return Data()
    }
}

let requestClosure =  { (endpoint: Endpoint<MultiTarget>, done: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
    
    guard var request = endpoint.urlRequest else { return }
    request.timeoutInterval = 20    //设置请求超时时间
    done(.success(request))
}

let endpointClosure = { (target: MultiTarget) -> Endpoint<MultiTarget> in
    
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let packagedParams = packetPublicParamters(originalParams: target.parameters)
    let endpoint = Endpoint<MultiTarget>(url: url,
                                         sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                         method: target.method,
                                         parameters: packagedParams,
                                         parameterEncoding: target.parameterEncoding)
    let headerFields: [String: String] = ["User-Agent": "iOS",
                                          "reqNo": TDWSystemInfo.appUUID(),
                                          "deviceNumber": TDWSystemInfo.idfaString(),
                                          "version": interfaceVersion]
    return endpoint.adding(newHTTPHeaderFields:headerFields)
}

// public Logger plugin instance.
let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let json = JSON(data: data)
        let prettyData =  try json.rawData()
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}


///MARK: 预留插件
public final class TDWDIYPlugin: PluginType {
    
    /// Called to modify a request before sending
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest{
        return request
    }
    
    /// Called immediately before a request is sent over the network (or stubbed).
    public func willSend(_ request: RequestType, target: TargetType){
        
    }
    
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType){
        
    }
    
    /// Called to modify a result before completion
    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}

// 为了解析请求参数里 data对应的是数组的特殊情况
public let kSpecialParamsKey = "kSpecialParamsKey"
///MARK: 封装加密公共参数。
func packetPublicParamters(originalParams params: [String: Any]? = nil) -> [String: Any]? {
    
    var paramter: [String: Any] = [:]
    paramter["token"] = TDWUserManager.shared.user.token ?? ""
    paramter["userId"] = TDWUserManager.shared.user.userId ?? ""
    if let param2 = params?[kSpecialParamsKey] {
        paramter["data"] = param2
    }else{
        paramter["data"] = params
    }
    //加密
    let encrptParam = ParameterPaser().paseParameter(JSON(paramter))
    return encrptParam
}

//MARK: - Response Handlers
extension Moya.Response {
    
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
    
    //MARK: 解密后的JSON数据
    func tdw_mapJSON() -> JSON {
        let res = ParameterPaser().parseResponse(self.data)
        return res
    }
}

