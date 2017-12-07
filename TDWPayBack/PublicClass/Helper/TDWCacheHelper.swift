//
//  TDWCacheHelper.swift
//  TuanDaiV4
//
//  Created by ZhengRS on 2017/11/21.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation

class TDWCacheHelper: NSObject {
    
    /// 清除Cookie
    class func clearCookieStorage() {
        guard HTTPCookieStorage.shared.cookies != nil else {
            return
        }
        for cookie in HTTPCookieStorage.shared.cookies! {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }
}
