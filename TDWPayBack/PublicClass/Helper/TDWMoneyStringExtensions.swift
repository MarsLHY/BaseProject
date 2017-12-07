//
//  TDWMoneyStringExtensions.swift
//  TDWKit
//
//  Created by John on 2017/10/13.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation

public extension String {

    /// 金额以逗号分隔及四舍五入保留二位有效数字
    /// 例如:  1329383.81523 --> 1,329,383.82
    ///       1329383.00123 --> 1,329,383.00
    /// return: 返回格式化后的金额字符串
    func tdw_stringSeparateByComma() -> String? {

        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        numberFormatter.roundingMode = .halfUp
        let formattedNumberString = numberFormatter.string(for: Double(self))
        return formattedNumberString
    }

    /// 金额以逗号分隔及四舍五入为整数
    /// 例如:  1329383.81523 --> 1,329,384
    ///       1329383.00123 --> 1,329,383
    /// return: 返回格式化后的金额字符串
    func tdw_stringSeparateByCommaInteger() -> String? {

        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .halfUp
        numberFormatter.positiveFormat = "###,##0;"
        let formattedNumberString = numberFormatter.string(for: Double(self))
        return formattedNumberString
    }

    /// 四舍五入,保留二位有效数字
    /// 例如:  1329383.81523 --> 1329383.82
    ///       1329383.00123 --> 1329383.00
    /// return: 返回格式化后的金额字符串
    func tdw_plainFormateWithYuan() -> String? {

        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "##0.00;"
        numberFormatter.roundingMode = .halfUp
        let formattedNumberString = numberFormatter.string(for: Double(self))
        return formattedNumberString
    }

    /// 将‘元’转化为‘万元’ 并保留二位有效数字 以逗号分隔(末尾的零会省略)
    /// 例如: 333323431553.23519221 ---> 33,332,343.16
    /// 例如: 333323431013.23519221 ---> 33,332,343.1
    /// return: 返回格式化后的金额字符串
    func tdw_formateMoneyForUnit() -> String? {

        if let doubleVaule = Double(self) {
            var tempValue = Decimal.init(doubleVaule)

            //10000金额表示
            let miriade = Decimal.init(10000)
            //除以10000金额
            tempValue.divide(by: miriade)

            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = NumberFormatter.Style.decimal
            numberFormat.maximumFractionDigits = 2
            numberFormat.roundingMode = .halfUp

            if let number = numberFormat.string(for: tempValue) {
                return number
            }
        }
        return nil
    }

    /// 例如:78372.5 ---> 万元
    ///     1272.5 ---> 元
    ///     10000.0 ---> 万元
    /// return: 返回金额的单位 万元或元
    func tdw_unitForMoney() -> String {

        var unitStr = "元"
        if let value = Double(self) {
            if value >= 10000.0 {
                unitStr = "万元"
            }
        }
        return unitStr
    }

    /// 去掉字符串末尾小数点后多余的零
    ///
    /// - Returns: 返回结果
    func tdw_StringDeletedUnnecessaryZero() -> String {

        var str = self
        if !str.contains(".") {
            return str
        }
        let length = str.characters.count
        for _ in 0  ..< length {
            if !str.hasSuffix("0") {
                break
            } else {
                let end = str.index(str.endIndex, offsetBy: -1)
                str = str.substring(to: end)
            }
        }
        if str.hasSuffix(".") {
            let end = str.index(str.endIndex, offsetBy: -1)
            str = str.substring(to: end)
            return str
        } else {
            return str
        }

    }
}
