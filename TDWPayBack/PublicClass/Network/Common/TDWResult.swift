//
//  TDWResult.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TDWSuccessProtocol {
    var statusCode: Int? {get set}
    var code: Int? {get set}
    var msg: String? {get set}
    var data: JSON {get set}
}

protocol TDWFailureProtocol {
    var statusCode: Int? {get set}
    var code: Int? {get set}
    var msg: String {get set}
    var data: JSON {get set}
}

struct TDWSuccess: TDWSuccessProtocol {
    var statusCode: Int?
    var code: Int?
    var msg: String?
    var data: JSON = JSON("")
}

struct TDWFailure: TDWFailureProtocol {
    var statusCode: Int?
    var code: Int?
    var msg: String = CommonMapTitle.badNetwork
    var data: JSON = JSON("")
}

enum TDWResult<T: TDWSuccessProtocol, E: TDWFailureProtocol> {
    
    case success(T)
    case failure(E)
    
    public init(value: T) {
        self = .success(value)
    }
    
    public init(value: E) {
        self = .failure(value)
    }
}

/// 团贷网接口返回的code 注意不是statusCode
enum TDWServerCode: Int {
    
    /// 服务器返回
    // 数据正常
    case normal = 200
    // 停机维护
    case serverMaintenance = 99999
    
    //／ 前端自定义
    case serverError = -5000  //服务器异常
    case networkError = -5001 //网络异常
}

