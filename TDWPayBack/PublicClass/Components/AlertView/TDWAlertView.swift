//
//  TDWAlertView.swift
//  TDWKit_Example
//
//  Created by John on 2017/10/16.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import TDWAlertView

/**
 使用示例:
 TDWAlertView.showAlert(style: .choose("你好啊"), inViewController: self, confirmClosure: {
 print("确认点击了")
 })

 使用注意: 如果想深度定制自己的alert，则需要直接用特定的类来创建。TDWAlertChooseTitleView（两个按钮带标题的）、TDWAlertChooseView（两个按钮不带标题）、TDWAlertTipTitleView（一个按钮带标题）、TDWAlertTipView（一个按钮不带标题）
 */

public enum TDWAlertView {

    static let maxLabelH = UIScreen.main.bounds.size.height * 0.5
    
    /// 两个按钮
    enum Choose {
        enum Style {
            case title(title: String)                                     /// 参数为标题文字，按钮默认为（取消、确定）
            case attrTitle(title: NSAttributedString)                     /// 参数为富文本标题文字，按钮默认为（取消、确定）
            case subTitle(title: String, subTitle: String)                /// 参数1为标题文字，参数2为描述文字，按钮默认为（取消、确定）
            case attrSubTitle(title: String, subTitle: NSAttributedString)/// 参数1为标题文字，参数2为富文本描述文字，按钮默认为（取消、确定）
        }

        static func showAlert(style: Style,
                                    inViewController: UIViewController,
                                    cancelButtonTitle: String? = "取消",
                                    confirmButtonTitle: String? = "确定",
                                    confirmClosure:(() -> Void)? = nil,
                                    cancleClosure: (() -> Void)? = nil) {
            switch style {
            case .title(let title):
                let alert = TDWAlertChooseView(msg: title)
                alert.confirmClourse = confirmClosure
                alert.cancelClourse = cancleClosure
                alert.cancelButtonTitle = cancelButtonTitle ?? "取消"
                alert.confirmButtonTitle = confirmButtonTitle ?? "确定"
                alert.showAlertView(inViewController: inViewController)

            case .subTitle(let title, let subTitle):
                let alert = TDWAlertChooseTitleView(title: title, msg: subTitle)
                alert.confirmClourse = confirmClosure
                alert.cancelClourse = cancleClosure
                alert.cancelButtonTitle = cancelButtonTitle ?? "取消"
                alert.confirmButtonTitle = confirmButtonTitle ?? "确定"
                alert.showAlertView(inViewController: inViewController)

            case .attrTitle(let subTitle):
                let alert = TDWAlertChooseView(msg: "")
                alert.attributeSubTitle = subTitle
                alert.confirmClourse = confirmClosure
                alert.cancelClourse = cancleClosure
                alert.confirmButtonTitle = confirmButtonTitle ?? "确定"
                alert.showAlertView(inViewController: inViewController)

            case .attrSubTitle(let title, let subTitle):
                let alert = TDWAlertChooseTitleView(title: title, msg: "")
                alert.attributeSubTitle = subTitle
                alert.confirmClourse = confirmClosure
                alert.cancelClourse = cancleClosure
                alert.confirmButtonTitle = confirmButtonTitle ?? "确定"
                alert.showAlertView(inViewController: inViewController)

            }
        }

    }
    /// 一个按钮
    enum Tip {
        enum Style {
            case title(title: String)                                     /// 参数为标题文字，按钮默认为（确定）
            case attrTitle(title: NSAttributedString)                     /// 参数为富文本标题文字，按钮默认为（确定）
            case subTitle(title: String, subTitle: String)                /// 参数1为标题文字，参数2为描述文字，按钮默认为（确定）
            case attrSubTitle(title: String, subTitle: NSAttributedString)/// 参数1为标题文字，参数2为富文本描述文字，按钮默认为（确定）
        }

        static func showAlert(style: Style,
                                 inViewController: UIViewController,
                                 confirmButtonTitle: String? = "确定",
                                 confirmClosure:(() -> Void)? = nil) {
            switch style {
            case .title(let title):
                let alert = TDWAlertTipView(msg: title)
                alert.subTitle = title
                alert.confirmButtonTitle = confirmButtonTitle
                alert.confirmClourse = confirmClosure
                alert.showAlertView(inViewController: inViewController)

            case .attrTitle(let attrTitle):
                let alert = TDWAlertTipView(msg: "")
                alert.attributeSubTitle = attrTitle
                alert.confirmButtonTitle = confirmButtonTitle
                alert.confirmClourse = confirmClosure
                alert.showAlertView(inViewController: inViewController)

            case .subTitle(let title, let subTitle):
                let alert = TDWAlertTipTitleView(title: title, msg: subTitle)
                alert.confirmButtonTitle = confirmButtonTitle
                alert.confirmClourse = confirmClosure
                alert.showAlertView(inViewController: inViewController)

            case .attrSubTitle(let title, let subTitle):
                let alert = TDWAlertTipTitleView(title: title, msg: "")
                alert.attributeSubTitle = subTitle
                alert.confirmButtonTitle = confirmButtonTitle
                alert.confirmClourse = confirmClosure
                alert.showAlertView(inViewController: inViewController)
            }
        }
    }

    /// 关闭按钮
    enum Close {
        enum Style {
            case title(title: String?, subTitle: String?)                /// 参数1为标题文字，参数2为描述文字，按钮默认为（确定）
            case attrTitle(title: String?, subTitle: NSAttributedString?)/// 参数1为标题文字，参数2为富文本描述文字，按钮默认为（确定）
        }

        static func showAlert(style: Style,
                              inViewController: UIViewController,
                              closeClosure:(() -> Void)? = nil) {
            switch style {
            case let .title(title , subTitle):
                let alert = TDWAlertCloseView()
                alert.title = title
                alert.subTitle = subTitle
                alert.closeClourse = closeClosure
                alert.showAlertView(inViewController: inViewController)

            case let .attrTitle(title, attrSubTitle):
                let alert = TDWAlertCloseView()
                alert.title = title
                alert.attributeSubTitle = attrSubTitle
                alert.closeClourse = closeClosure
                alert.showAlertView(inViewController: inViewController)
            }
        }
    }
}


