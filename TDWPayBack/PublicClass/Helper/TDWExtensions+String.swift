//
//  TDWPersonalData+String.swift
//  TuanDaiV4
//
//  Created by John on 2017/10/19.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation

extension String {

    /// 对电话号码进行模糊
    ///
    /// - Parameters:
    ///   - front: 电话前面几位显示真正号码
    ///   - behind: 电话后面几位显示真正号码
    /// - Returns: 返回模糊后的电话号码
    func tdw_fuzzyPhoneNo(_ front: Int = 3, behind: Int = 2) -> String {

        guard front >= 0, behind >= 0 else {
            return self
        }

        guard count > front + behind else {
            return self
        }

        let starCount = count - (front + behind)
        var starStr = ""
        for _ in 1...starCount {
            starStr = starStr + "*"
        }

        if let prefix = tdw_substring(to: front), let suffix = tdw_substring(from: count - behind) {
            return prefix + starStr + suffix
        }
        return self
    }
    
    static func tdw_isEmpty(_ string: String?) -> Bool {
        if let str = string {
            let resultStr = str.trimmingCharacters(in: CharacterSet.whitespaces)
            if resultStr.isEmpty {
                return true
            }else{
                return false
            }
        }
        return true
    }
}
