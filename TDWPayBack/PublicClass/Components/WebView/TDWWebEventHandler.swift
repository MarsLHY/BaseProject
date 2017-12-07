//
//  TDWWKWebViewEventHandler.swift
//  TDWCashLoan
//
//  Created by John on 2017/8/18.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

import Foundation
import WebViewJavascriptBridge
import SwiftyJSON

class TDWWebEventHandler {
    
    var shareType: Any?
    
    var shareCallBlock: WVJBResponseCallback?
    
    weak var webview: TDWWebController?
    init(_ webView: TDWWebController) {
        self.webview = webView
    }
    
    /// MARK-:所有的处理事件
    func jsCallOCFuncName(_ funcName: String, dictParams: Dictionary<String, Any >?, dataParam: Any?, responCallBack: WVJBResponseCallback?) {
        
        if let  funcNameEnum = TDWJS_2_iOSFuncName(rawValue: funcName) {
            switch funcNameEnum {
            /// 跳转到新界面
            case .appNewPage:
                jumpToNewPage(dictParams: dictParams, dataParam: dataParam, responCallBack: responCallBack)
            }
        }
    }
    
    /// MARK-:具体处理逻辑
    //跳转到新的界面
    fileprivate func jumpToNewPage(dictParams: Dictionary<String, Any >?, dataParam: Any?, responCallBack: WVJBResponseCallback?){
        print(dictParams ?? "参数为空")
        /// 取值成功
        if dictParams != nil{
            if let url = dictParams!["url"] as? String, let title = dictParams!["title"] as? String {
                self.webview?.jumpToNewPage(title, url: url)
            }
        }
    }
}
