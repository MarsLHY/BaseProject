//
//  TDWAlertViewBridge.swift
//  TuanDaiV4
//
//  Created by yinzhuoxian on 2017/11/29.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation
import UIKit

class TDWAlertViewBridge: NSObject {
    class func showCloseAlertView(title: String?, subTitle: NSAttributedString?, inViewController: UIViewController, closure:(() -> Void)? = nil) {
        TDWAlertView.Close.showAlert(style: .attrTitle(title: title, subTitle: subTitle), inViewController: inViewController, closeClosure: closure)
    }
}
