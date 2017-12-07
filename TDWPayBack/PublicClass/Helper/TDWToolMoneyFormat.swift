//
//  TDWToolMoneyFormat.swift
//  TuanDaiV4
//
//  Created by ZhengRS on 2017/9/26.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation

class TDWToolMoneyFormat {
    
    /// 金额字符串格式化： 金额大于1万 会带有单位 “万”，具体规则如下：    ---> "我"
    ///     金额等于“0”时  显示“0.00”
    ///     金额大于“0”小于1万时 显示到两位小数(四舍五入法)，比如：“1.00”、“1.10”、“123.22”
    ///     金额大于等于1万时 显示科学计数法数到两位小数加万字（舍弃法），如：“1.00万”、“1.10万”、“123.45万”、“12,123.45万”
    ///
    /// - paramter: money 需要格式化的金额字符串。金额字符串为nil或不是数字，则return ""
    /// - return: 返回格式化后的字符串。对于是nil 或 不是数字的金额字符串，为“”。
    class func moneyFormatWithTenThousandUnit(money value: String?) -> String {
        guard value != nil else {
            return ""
        }
        //去掉字符串首尾空格
        let moneyStr = value!.trimmingCharacters(in: CharacterSet.whitespaces)
        // 是否是整数或小数
        if !isIntegerOrDecimal(money: moneyStr) {
            return ""
        }
        let moneyDecimal = Decimal(string: moneyStr)
        guard moneyDecimal != nil else {
            return ""
        }
        var mode = NumberFormatter.RoundingMode.halfUp
        var result = moneyDecimal!
        let compareValue = Decimal(10000)
        let isLessThanOrEqual = compareValue.isLessThanOrEqualTo(Decimal.abs(result))
        if isLessThanOrEqual {
            result.divide(by: compareValue)
            mode = .down
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        numberFormatter.roundingMode = mode
        let reslutString = numberFormatter.string(for: result)
        guard reslutString != nil else {
            return ""
        }
        if isLessThanOrEqual {
            return reslutString! + "万"
        }
        return reslutString!
    }
    /// 金额字符串格式化： 金额大于1万 会带有单位 “万”，具体规则如下：    ---> "我"
    ///     金额等于“0”时  显示“0.00”
    ///     金额大于“0”小于1万时 显示到两位小数(四舍五入法)，比如：“1.00”、“1.10”、“123.22”
    ///     金额大于等于1万时 显示科学计数法数到两位小数加万字（舍弃法），如：“1.00万”、“1.10万”、“123.45万”、“12,123.45万”
    ///
    /// - paramter: money 需要格式化的金额字符串。金额字符串为nil或不是数字，则return ""
    /// - return: 返回格式化后的字符串。对于是nil 或 不是数字的金额字符串，为“”。
    class func moneyFormatWithTenThousandUnit(money value: NSDecimalNumber?) -> String {
        guard value != nil else {
            return ""
        }
        var mode = NumberFormatter.RoundingMode.halfUp
        var result = value!
        let tenThousand = NSDecimalNumber(value: 10000)
        let compareResult = tenThousand.compare(result)
        if compareResult == .orderedAscending || compareResult == .orderedSame {
            result = result.dividing(by: tenThousand)
            mode = .down
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        numberFormatter.roundingMode = mode
        let reslutString = numberFormatter.string(for: result)
        guard reslutString != nil else {
            return ""
        }
        if compareResult == .orderedAscending || compareResult == .orderedSame {
            return reslutString! + "万"
        }
        return reslutString!
    }
    
    /// 金额字符串格式化： 金额保留二位小数，具体规则如下：   ---> "我--余额、网贷、智享、定期"
    ///     金额等于“0”时  显示“0.00”
    ///     金额大于“0”时 显示到两位小数(四舍五入)，比如：“1.00”、“1.10”、“123.22”、“12,123.22”
    ///
    /// - paramter: money 需要格式化的金额字符串。金额字符串为nil或不是数字，则return ""
    /// - return: 返回格式化后的字符串。对于是nil 或 不是数字的金额字符串，为“”。
    class func moneyFormat(money value: String?) -> String {
        
        guard value != nil else {
            return ""
        }
        //去掉字符串首尾空格
        let moneyStr = value!.trimmingCharacters(in: CharacterSet.whitespaces)
        // 是否是整数或小数
        if !isIntegerOrDecimal(money: moneyStr) {
            return ""
        }
        let moneyDecimal = Decimal(string: moneyStr)
        guard moneyDecimal != nil else {
            return ""
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        numberFormatter.roundingMode = .halfUp
        let reslutString = numberFormatter.string(for: moneyDecimal!)
        guard reslutString != nil else {
            return ""
        }
        return reslutString!
    }
    /// 金额字符串格式化： 金额保留二位小数，具体规则如下：   ---> "我--余额、网贷、智享、定期"
    ///     金额等于“0”时  显示“0.00”
    ///     金额大于“0”时 显示到两位小数(四舍五入)，比如：“1.00”、“1.10”、“123.22”、“12,123.22”
    ///
    /// - paramter: money 需要格式化的金额字符串。金额字符串为nil或不是数字，则return ""
    /// - return: 返回格式化后的字符串。对于是nil 或 不是数字的金额字符串，为“”。
    class func moneyFormat(money value: NSDecimalNumber?) -> String {
        
        guard value != nil else {
            return ""
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        numberFormatter.roundingMode = .halfUp
        let reslutString = numberFormatter.string(for: value!)
        guard reslutString != nil else {
            return ""
        }
        return reslutString!
    }
    
    /// 区配整数或小数的正则表达式
    private class func isIntegerOrDecimal(money input: String) -> Bool {
        let regex = "^[-+]?[0-9]+([.]{0,1}[0-9]+){0,1}$"
        return input.tdw_matches(pattern: regex)
    }
}
