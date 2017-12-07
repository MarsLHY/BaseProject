//
//  TDWMoyaProvider.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Result

protocol TDWMoyaProviderProtocol {
    
    /// 网络请求
    /// target: 网络请求API
    /// completion: 请求结果回调
    /// return Cancellable:用于取消网络请求
    @discardableResult
    func tdw_request(_ target: MultiTarget, completion: @escaping CompletionCallBack) -> Cancellable
    
    /// 网络请求
    /// target: 网络请求API
    /// queue: 网络请求结果后的线程
    /// progress: 进度
    /// completion: 请求结果回调
    /// return Cancellable:用于取消网络请求
    @discardableResult
    func tdw_request(_ target: MultiTarget,
                     queue: DispatchQueue?,
                     progress: Moya.ProgressBlock?,
                     completion: @escaping CompletionCallBack) -> Cancellable
    
}

// 请求发送实体
let TDWMoyaProvider: TDWMoyaProviderProtocol = TDWProvider(endpointClosure:endpointClosure,
                                                           requestClosure:requestClosure,
                                                           plugins: [TDWDIYPlugin(),networkLoggerPlugin])
// 定义请求完成的回调
typealias CompletionCallBack = (_ result: TDWResult<TDWSuccess, TDWFailure>) -> Void


internal class TDWProvider: MoyaProvider<MultiTarget>, TDWMoyaProviderProtocol {
    
    /// 网络请求。
    @discardableResult
    func tdw_request(_ target: MultiTarget, completion: @escaping CompletionCallBack) -> Cancellable {
        
        return tdw_request(target, queue: nil, completion: completion)
    }
    
    /// Designated request-making method with queue option. Returns a `Cancellable` token to cancel the request later.
    @discardableResult
    func tdw_request(_ target: MultiTarget,
                     queue: DispatchQueue?,
                     progress: Moya.ProgressBlock? = nil,
                     completion: @escaping CompletionCallBack) -> Cancellable {
        
        return request(target, queue: queue, progress: progress, completion: { (result) in
            
            switch result {
            case let .success(moyaResponse):
                
                do {
                    /// filter 200 - 299
                    let response = try moyaResponse.filterSuccessfulStatusCodes()
                    
                    let json = moyaResponse.tdw_mapJSON()
                    let statusCode = response.statusCode
                    let code = json["code"].int  //99999
                    let msg = json["message"].string
                    let data = json["data"]
                    if code != nil && code == TDWServerCode.normal.rawValue { //成功
                        var successResult = TDWSuccess()
                        successResult.statusCode = statusCode
                        successResult.code = code
                        successResult.data = data
                        successResult.msg = msg
                        completion(TDWResult(value: successResult))
                    }else{//服务器异常
                        
                        //停机维护
                        //TDWServerResultHandle.shared.handleServerMainenace(serverReturn: json, methodName: target.path)
                        var failResult = TDWFailure()
                        failResult.statusCode = statusCode
                        failResult.code = code
                        if msg != nil && !msg!.isEmpty {
                            failResult.msg = msg!
                        }else{
                            failResult.msg = CommonMapTitle.serverError
                        }
                        failResult.data = data
                        completion(TDWResult(value: failResult))
                    }
                } catch {
                    
                    // statusCode out of 200..299
                    var failResult = TDWFailure()
                    failResult.statusCode = moyaResponse.statusCode
                    failResult.msg = CommonMapTitle.serverError
                    failResult.code = TDWServerCode.serverError.rawValue //服务器异常
                    completion(TDWResult(value: failResult))
                }
                
            case let .failure(error)://网络异常
                
                var failResult = TDWFailure()
                failResult.statusCode = error.response?.statusCode
                failResult.code = TDWServerCode.networkError.rawValue //网络异常
                failResult.msg = CommonMapTitle.badNetwork
                completion(TDWResult.init(value: failResult))
            }
        })
    }
    
}
