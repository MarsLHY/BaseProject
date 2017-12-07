//
//  TDWSettingAPI.swift
//  TDWCashLoan
//
//  Created by hulh on 2017/8/7.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

import Foundation

import Moya

public enum TDWSettingAPI {
    //推送设置
    case updateNotify(messageNotification:Bool)
    //意见反馈
    case feedBack(content:String)
    //app版本更新
    //case appVersionUP
}

extension TDWSettingAPI: TargetType {
    public var path:String {
        switch self {
        case .updateNotify(_):
            return "user/updateNotification"
        case .feedBack(_):
            return "feedback/add"
//        case .appVersionUP:
//            return "web/updateVersion"
        }
        
        
    }
    public var parameters: [String: Any]? {
        
        switch self {
        case .updateNotify(let messageNotification ):
            return ["messageNotification":messageNotification]
        case .feedBack(let content):
            return ["content":content]
//        case .appVersionUP:
//            return nil
        }
    }
}
