//
//  TDWConstant.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

/// MARK: 网络环境配置
public enum TDWAppEnvironment {
    case test // 测试
    case preProduction // 预发布(灰度)
    case production // 发布
}
/// 设置当前网络环境
public let appEnvironment: TDWAppEnvironment = .production
/// 是否是beta版本
public let isBetaAPP: Bool = false
/// 接口版本号
public let interfaceVersion: String = "1.0.0"


struct TDWPhoneConstant {
    // 客服电话
    static let customer = "4001690188"
}

let key_firstInstallAPP = "key_firstInstallAPP"


/// MARK: 神策埋点事件
public enum TDWSensorsEvent: String {
    case AppInstall // App 激活(渠道跟踪)
    case XJDLogin   // 登录
    case XJDRegist  // 注册
}

