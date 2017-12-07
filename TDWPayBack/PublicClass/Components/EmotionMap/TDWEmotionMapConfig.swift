//
//  TDWEmotionMapConfig.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

// 通用的情感图类型
enum TDWEmotionMapType {
    case networkError //网络异常
    case serverError  //服务器异常
    case noRecord     //无记录
}

// 通用的情感图图片名
struct CommonMapImageName {
    //网络异常
    static let noNetwork = "empty_full_nonetwork"
    //服务器异常
    static let serverError = "empty_full_system_bad"
    //无数据
    static let noData = "empty_full_nodata"
}

// 通用的情感图title
struct CommonMapTitle {
    static let badNetwork = "网络不给力,请稍后再试"
    static let serverError = "服务器异常,加载出错了"
    static let noData = "暂无相关数据"
}

// 通用的情感图subtitle
let CommonMapSubTitle = "点击屏幕，重新加载"

/// 情感图样式
enum EmotionMapStyle {
    case map
    case hud
}

/// 情感图位于View的哪个位置，一般全局的情感图用top，半屏情感图用middle。
enum EmotionMapPosition {
    case top   //全屏情感图 default
    case middle //半屏情感图
}
