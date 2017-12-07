//
//  TDWWebController.swift
//  TDWCashLoan
//
//  Created by John on 2017/8/18.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

import Foundation
import WebKit
import WebViewJavascriptBridge


class TDWWebController: TDWBaseViewController {
    
    /// 预留闭包
    typealias Completed = ()->()
    var finishBlock: Completed?
    var closeBlock: Completed?
    var riskEvaluationFinishBlock: Completed?
    
    /// UI
    //主视图
    lazy fileprivate var webView: WKWebView = {
        var webViewConfigration: WKWebViewConfiguration = WKWebViewConfiguration()
        
        var preferences: WKPreferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        webViewConfigration.preferences = preferences
        let rect =  CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(UIScreen.main.bounds.size.height))
        return WKWebView(frame: rect, configuration: webViewConfigration)
    }()
    lazy fileprivate var progressView: UIProgressView = {
        let progressView: UIProgressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = UIColor.orange
        progressView.trackTintColor = UIColor.lightGray
        return progressView
    }()
    
    //左边按钮
    fileprivate var backButtonItem: UIBarButtonItem?
    fileprivate var closeButtonItem: UIBarButtonItem?
    fileprivate var shouldShowCloseItem: Bool = false
    lazy fileprivate var spaceForLeftItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
    }()
    
    /// 业务
    //业务处理对象
    fileprivate var webViewBridge: WKWebViewJavascriptBridge?//第三方对象
    var actionInteraction: TDWWebActionInteraction?//JSOC事件处理器
    //KVO数据暂存
    fileprivate var estimatedProgress: NSObject = NSObject()
    //事件处理器是否初始化成功
    fileprivate var hasInitActionInteractionSuccess: Bool = false
    //业务数据
    var urlLink: String
    fileprivate var hasDidLoaded = false
    var isSecondNewPage: Bool = false
    var isFinishLoaded: Bool = false
    
    init(urlLink urlStr: String,withWebTitle webTitle: String?) {
        
        self.urlLink = urlStr.trimmingCharacters(in: .whitespaces)
        
        super.init(nibName: nil, bundle: nil)
        
        title = webTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK-:lifeCircle
    deinit {
        if hasDidLoaded {
            
            removeObserver()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        //初始化
        initLeftItem()
        initRightItem()
        initWebView()
        initProgressView()
        initLayout()//布局
        initAddObserver()//监听通知
        
        //加载
        loadWebView()
        
        hasDidLoaded = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.hidesBackButton = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        actionInteraction?.iOSCallJsContext(TDWiOS_2_JSFuncName.LifeCircle, Arguments: TDWiOS_2_JSFuncName.LifeCircleEnum.viewWillDisMiss.rawValue)
    }
    
    //Action
    func closeAction() {
        navigationController?.popViewController(animated: true)
        if closeBlock != nil {
            closeBlock!()
        }
    }
    func backAction() {
        if webView.canGoBack {
            if let backItem = webView.backForwardList.backList.last{
                webView.go(to: backItem)
            }else{
                navigationController?.popViewController(animated: true)
                if finishBlock != nil {
                    finishBlock!()
                }
                return
            }
            
            if !shouldShowCloseItem {
                shouldShowCloseItem = true
                updateLeftItems()
            }
        }else{
            navigationController?.popViewController(animated: true)
            if finishBlock != nil {
                finishBlock!()
            }
        }
    }
    func heplerAction() {
//        if let helperVc = TDHelperCenterViewController(urlLink: TDHelperCenterURL, withWebTitle: "帮助中心"){
//            self.navigationController?.pushViewController(helperVc, animated: true)
//        }
    }
    
    //初始化
    private func initLeftItem(){
        
        closeButtonItem = barButton(UIImage(named: "public_back_Arrow_close"), target: self, action: #selector(self.closeAction), isBack: false)
        backButtonItem = barButton(UIImage(named: "back_arrow"), target: self, action: #selector(self.backAction), isBack: true)
        
        guard backButtonItem != nil else {
            return
        }
        navigationItem.setLeftBarButtonItems([backButtonItem!], animated: true)
    }
    private func initRightItem(){
        if isSecondNewPage {
            let rightIamge = UIImage(named: "find_navigation_help_w")?.withRenderingMode(.alwaysOriginal)
            let rightItem = UIBarButtonItem(image: rightIamge, style: .plain, target: self, action: #selector(heplerAction))
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    private func initWebView() {
        view.addSubview(webView)
//        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webViewBridge = WKWebViewJavascriptBridge(for: webView)
        webViewBridge?.setWebViewDelegate(self)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &estimatedProgress)
        
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    private func initProgressView() {
        view.addSubview(progressView)
    }
    private func initLayout(){
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(1)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    private func initAddObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    private func removeObserver(){
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        NotificationCenter.default.removeObserver(self)
    }//通知移除
    
    //KVO监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if(context == &estimatedProgress){
            
            if let newProgress: Float = change?[NSKeyValueChangeKey.newKey] as? Float {
                if newProgress == 1 {
                    progressView.setProgress(1, animated: true)
                    let time: TimeInterval = 0.7
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        self.progressView.isHidden = true
                        self.progressView.setProgress(0, animated: false)
                    }
                }else{
                    progressView.isHidden = false
                    progressView.setProgress(newProgress, animated: true)
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    /// MARK-:左边按钮逻辑
    fileprivate func updateLeftItems() {
        
        guard navigationItem.leftBarButtonItems != nil else {
            return
        }
        
        guard backButtonItem != nil, closeButtonItem != nil else {
            return
        }
        
        let leftItemCount: Int = navigationItem.leftBarButtonItems!.count
        
        if leftItemCount == 3 && shouldShowCloseItem {
            return
        }
        if leftItemCount == 1 && !shouldShowCloseItem {
            return
        }
        
        if leftItemCount == 3 && !shouldShowCloseItem {
            //删除closeItem
            let closeItemIndex = navigationItem.leftBarButtonItems?.index(of: closeButtonItem!)
            guard closeItemIndex != nil else {
                return
            }
            navigationItem.leftBarButtonItems?.remove(at: closeItemIndex!)
            
            //删除站位Item
            let spaceItemIndex = navigationItem.leftBarButtonItems?.index(of: spaceForLeftItem)
            guard spaceItemIndex != nil else {
                return
            }
            navigationItem.leftBarButtonItems?.remove(at: spaceItemIndex!)
        }
        
        if leftItemCount == 1 && shouldShowCloseItem {
            navigationItem.leftBarButtonItems?.append(closeButtonItem!)
            navigationItem.leftBarButtonItems?.append(spaceForLeftItem)
        }
    }
    fileprivate func barButton(_ image: UIImage?, target: Any?, action: Selector?, isBack: Bool) -> UIBarButtonItem {
        let barButton = UIButton()
        barButton.frame = CGRect(x:0, y:0, width:24, height:41)
        if isBack {
            barButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        }
        barButton.setImage(image, for: UIControlState())
        barButton.addTarget(target!, action: action!, for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: barButton)
        
        return barItem
    }
    
    /// MARK-:loadView
    func loadWebView(){
        if let url = URL(string: urlLink) {
            if !webView.isLoading {
                let request: URLRequest = URLRequest.init(url: url)
                webView.load(request)
            }
        }
    }
    
    /// MARK-:Public
    func jumpToNewPage(_ title: String, url: String) {
        let newWebVC = TDWWebController(urlLink: url, withWebTitle: title)
        newWebVC.isSecondNewPage = true
        self.navigationController?.pushViewController(newWebVC, animated: true)
    }
}

//#pragma mark - 监听通知
extension TDWWebController{
    func applicationDidEnterBackground(_ notification: NSNotification) {
        actionInteraction?.iOSCallJsContext(TDWiOS_2_JSFuncName.LifeCircle, Arguments: TDWiOS_2_JSFuncName.LifeCircleEnum.enterBackGroud.rawValue)
    }
    func applicationWillEnterForeground(_ notification: NSNotification) {
        actionInteraction?.iOSCallJsContext(TDWiOS_2_JSFuncName.LifeCircle, Arguments: TDWiOS_2_JSFuncName.LifeCircleEnum.enterForeground.rawValue)
    }
}

//网页跳转生命周期
extension TDWWebController: WKNavigationDelegate{
    //在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("decidePolicyFordecidePolicyFor---在发送请求之前，决定是否跳转\(navigationAction.request.url?.absoluteString ?? "")")
        
        guard navigationAction.request.url != nil else {
            return
        }
        if WebViewJavascriptBridgeBase().isWebViewJavascriptBridgeURL(navigationAction.request.url!) {
            return
        }
//        //旧版OC的逻辑
//        let urlStr = navigationAction.request.url?.absoluteString
//        if urlStr == nil || (urlStr != nil && urlStr!.characters.count == 0) {
//            decisionHandler(.cancel)
//            return
//        }
//        
        //一般性逻辑
//        let hostName: String?  = navigationAction.request.url?.host?.lowercased()
//        if navigationAction.navigationType == .linkActivated && hostName != nil {
//            print("decidePolicyFor---跳转之前的host的name:\(hostName!)")
//            
//            UIApplication.shared.openURL(navigationAction.request.url!)//跨域的用Safari
//            
//            decisionHandler(.cancel)//不允许跨域
//        }else{
//            
//            
//        }
        
        self.progressView.alpha = 1.0
        decisionHandler(.allow)
    }
    
    //在响应完成时，调用的方法。如果设置为不允许响应，web内容就不会传过来
    //接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        print("didReceiveServerRedirectForProvisionalNavigation--接收到服务器跳转请求之后调用")
    }
    
    //开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("didStartProvisionalNavigation--开始加载时调用\(navigation)")
    }
    //在响应完成时,决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("decidePolicyForNavigationResponse--在响应完成时，调用的方法")
        decisionHandler(.allow)
    }
    
    //当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommitNavigation--当内容开始返回时调用")
    }
    
    //页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish--页面加载完成之后调用")
        print("标题--\(String(describing: webView.title))")
        if title == nil {
            title = webView.title
        }
        if webView.isLoading {
            return
        }
        view.tdw_hideLoading()
        //初始化事件接收器
        guard webViewBridge != nil, !hasInitActionInteractionSuccess else {
            return
        }
        actionInteraction = TDWWebActionInteraction(webViewBridge: webViewBridge!, webController: self)//实例化事件处理器
        actionInteraction?.iOSCallJsContext(TDWiOS_2_JSFuncName.LifeCircle, Arguments: TDWiOS_2_JSFuncName.LifeCircleEnum.finishLoad.rawValue)//告诉JS lifecircle
        
        hasInitActionInteractionSuccess = true
        isFinishLoaded = true
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.tdw_hideLoading()
        print("didFail--页面加载失败时调用\(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation--页面加载失败时调用\(error)")
    }
}

/// 网页弹窗一般性操作取消拦截
/*

extension TDWWebController : WKUIDelegate{
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertVC = UIAlertController.init(title: "提醒", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertVC = UIAlertController.init(title: "确认框", message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertVC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertVC = UIAlertController.init(title: "输入框", message: prompt, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.backgroundColor = UIColor.orange
        }
        
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            completionHandler(alertVC.textFields?.last?.text)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
 
 */
