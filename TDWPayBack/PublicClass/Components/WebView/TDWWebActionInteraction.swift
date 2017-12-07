//
//  TDWWebActionInteraction.swift
//  TDWCashLoan
//
//  Created by John on 2017/8/18.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

import Foundation
import UIKit
import WebViewJavascriptBridge

///////////////////////事件处理器，包括注册与处理逻辑//////////////////////////
enum TDWJS_2_iOSFuncName: String {
    
    case appNewPage = "ToAppNewPage"//跳转到新界面
    static let js_2_iosFuncNames = [TDWJS_2_iOSFuncName.appNewPage.rawValue]
}

enum TDWiOS_2_JSFuncName: String {
    case LifeCircle = "ToAppLifeCycle"
    
    enum LifeCircleEnum: String {
        case finishLoad = "1"
        case viewWillDisMiss = "2"
        case enterBackGroud = "3"
        case enterForeground = "4"
    }
}


protocol WKWebViewInteractionProtocol {
    weak var webViewBridge: WKWebViewJavascriptBridge?{ get }
    
    typealias CompleteHandle = (_ dict: Dictionary<String, Any >?,_ data: Any?,_ resposeCallClose: WVJBResponseCallback?)->Void
    func webViewRegistFunc(_ funcName: String, strikeHandle:@escaping CompleteHandle)//注册给JS调用
    func iOSCallJsContext(_ funcName: String, Arguments: Any?)//直接调用js
}
class TDWWebActionInteraction: WKWebViewInteractionProtocol {
    
    weak var webViewBridge: WKWebViewJavascriptBridge?//第三方桥接器
    weak var webView: TDWWebController?
    fileprivate var eventHandler: TDWWebEventHandler?//OC 事件处理器
    
    /// MARK-:初始化
    init(webViewBridge: WKWebViewJavascriptBridge, webController: TDWWebController) {
        self.webViewBridge = webViewBridge
        self.webView = webController
        eventHandler = TDWWebEventHandler(webController)
        
        //默认注册事件
        registAll()
    }
    //self regist init
    //注册方法给JS调用
    private func registAll(){
        let shouldCallBackFuncNames = TDWJS_2_iOSFuncName.js_2_iosFuncNames
        for funcName in shouldCallBackFuncNames {
            webViewRegistFunc(funcName, strikeHandle: { [weak self] (dataDict, data, responCallBack) in
                
                self?.eventHandler?.jsCallOCFuncName(funcName, dictParams: dataDict, dataParam: data, responCallBack: responCallBack)
            })
        }
    }
    
    /// MARK-:Public
    //public OC调用JS
    func iOSCallJsContext(_ funcName: TDWiOS_2_JSFuncName, Arguments: Any?) {
        iOSCallJsContext(funcName.rawValue, Arguments: Arguments)
    }//swift内部使用
    func iOSCallJsContext(_ funcName: String, Arguments: Any?) {
        if Arguments != nil {
            webViewBridge?.callHandler(funcName, data: Arguments!, responseCallback: { (type) in
                print("前端的callBack回的值\(String(describing: type))")
            })
        }else{
            webViewBridge?.callHandler(funcName)
        }
    }//通用
    
    //注册事件单个
    func webViewRegistFunc(_ funcName: String, strikeHandle: @escaping WKWebViewInteractionProtocol.CompleteHandle) {
        webViewBridge?.registerHandler(funcName, handler: { (responseDict, resposeCallBack) in
            if let responseDataDict = responseDict as? Dictionary<String, Any> {
                
                strikeHandle(responseDataDict, responseDict, resposeCallBack)
            }else{
                
                strikeHandle(nil, responseDict ,resposeCallBack)
            }
        })
    }
}

