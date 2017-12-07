//
//  TDWExtension+NSMutableAttributedString.swift
//  TuanDaiV4
//
//  Created by yinzhuoxian on 2017/11/29.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation
import UIKit

fileprivate let paragraphFontWithLinespacing: [CGFloat: CGFloat] = [12.0: 6,
                                                                    13.0: 6,
                                                                    14.0: 7,
                                                                    15.0: 8,
                                                                    16.0: 8,
                                                                    17.0: 9,]
extension NSMutableAttributedString {
    
    /// 团贷网常用字号默认间距
    ///
    /// - Parameters:
    ///   - fontSize: 15
    ///   - color: 0x333333
    ///   - textAlignment: .left
    func tdw_formatParagraphString(fontSize: CGFloat, color: UIColor = UIColor(TDWValueRGB: 0x333333), textAlignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        var lineSpacing: CGFloat = 0
        if paragraphFontWithLinespacing.keys.contains(fontSize) {
            lineSpacing = paragraphFontWithLinespacing[fontSize]! - (font.lineHeight - font.pointSize)
        }
        _ = self.tdw_addAttributeTextColor(color: color).tdw_addAttributedFont(font: font).tdw_addParagraphStyle(textAlignment: textAlignment, lineSpacing: lineSpacing)
        return self
    }
    
    func tdw_addAttributeTextColor(color: UIColor) -> NSMutableAttributedString {
        _ = self.tdw_addAttributeTextColor(color: color, range: NSMakeRange(0, self.length))
        return self
    }
    
    func tdw_addAttributeTextColor(color: UIColor, range: NSRange) -> NSMutableAttributedString {
        self.removeAttribute(NSForegroundColorAttributeName, range: range)
        self.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        return self
    }
    
    func tdw_addAttributedFont(font: UIFont) -> NSMutableAttributedString {
        _ = self.tdw_addAttributedFont(font: font, range: NSMakeRange(0, self.length))
        return self
    }
    
    func tdw_addAttributedFont(font: UIFont, range: NSRange) -> NSMutableAttributedString {
        self.removeAttribute(NSFontAttributeName, range: range)
        self.addAttribute(NSFontAttributeName, value: font, range: range)
        return self
    }
    
    func tdw_addParagraphStyle(textAlignment: NSTextAlignment, lineSpacing: CGFloat, paragraphSpacing: CGFloat = 0, lineBreakMode: NSLineBreakMode = .byCharWrapping) -> NSMutableAttributedString {
        _ = self.tdw_addParagraphStyle(textAlignment: textAlignment, lineSpacing: lineSpacing, paragraphSpacing: paragraphSpacing, lineBreakMode: lineBreakMode, range: NSMakeRange(0, self.length))
        return self
    }
    
    func tdw_addParagraphStyle(textAlignment: NSTextAlignment, lineSpacing: CGFloat, paragraphSpacing: CGFloat, lineBreakMode: NSLineBreakMode, range: NSRange) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        //文本对齐方式
        paragraphStyle.alignment = textAlignment
        //文本行间距
        paragraphStyle.lineSpacing = lineSpacing
        //段落间距
        paragraphStyle.paragraphSpacing = paragraphSpacing
        //换行模式
        paragraphStyle.lineBreakMode = lineBreakMode
        self.removeAttribute(NSParagraphStyleAttributeName, range: range)
        self.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        return self
    }
}
