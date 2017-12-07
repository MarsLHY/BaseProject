//
//  UIViewExtensionTDWHud.swift
//  TuanDaiV4
//
//  Created by ZhengRuSong on 2017/7/27.
//  Copyright © 2017 Dee. All rights reserved.
//

import Foundation
import MBProgressHUD

enum TDWLoadingStyle {
    case none
    case gray
}


extension UIView {
    
    /// MARK: Loading
    func tdw_showLoading(_ title: String? = nil, style: TDWLoadingStyle) {
        
        if let loading = self.tdw_loading?.customView as? TDWLoadingView {
            loading.configData(title, style: style)
        }else{
            
            let hud = MBProgressHUD.init(view: self)
            guard let hud2 = hud else {
                return
            }
            self.tdw_loading = hud2
            hud2.mode = MBProgressHUDMode.customView
            let loading = TDWLoadingView()
            loading.configData(title, style: style)
            let size = loading.loadingViewSize()
            loading.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            hud2.customView = loading;
            hud2.color = UIColor.clear
            hud2.removeFromSuperViewOnHide = true
            self.addSubview(hud2)
            hud2.show(false)
            loading.startLoadingAnimation()
        }
    }
    /// 隐藏loading。
    func tdw_hideLoading() {
        if let loading =  self.tdw_loading {
            loading.hide(false)
            self.tdw_loading = nil
        }
    }
    
    /// MARK: 显示hud，显示hud期间不允许用户对被遮盖的视图进行交互。
    func tdw_showHud(hudTitle title: String?) {
        if title == nil || title!.isEmpty {
            return
        }
        if let hud = self.tdw_hud {
            hud.detailsLabelText = title;
        }else {
            let hud = MBProgressHUD.init(view: self)
            guard let hud2 = hud else {
                return
            }
            self.tdw_hud = hud2
            hud2.mode = MBProgressHUDMode.text
            hud2.detailsLabelText = title;
            hud2.margin = 15
            hud2.detailsLabelFont = .systemFont(ofSize: 15)
            hud2.cornerRadius = 8.0
            hud2.removeFromSuperViewOnHide = true;
            self.addSubview(hud2)
            hud2.show(false)
        }
    }
    
    /// 隐藏hud
    func tdw_hideHud() {
        if let hud = self.tdw_hud {
            hud.hide(false)
            self.tdw_hud = nil
        }
    }
    
    /// 几秒后自动隐藏的hud.
    ///
    /// - parameter title: hud的标题.
    /// - parameter seconds: 几秒后自动隐藏.
    /// - parameter underlyingViewsEnabled: 显示hud时 在hud下面的视图是否允许用户进行交互，默认为yes.
    func tdw_showAutoHideHud(hudTitle title: String?,
                             hideAfter seconds: Double = 2.0,
                             userInteraction underlyingViewsEnabled: Bool = true) {
        
        if title == nil || title!.isEmpty {
            return
        }
        if let hud = self.tdw_autoHideHud {
            NSObject.cancelPreviousPerformRequests(withTarget: hud)
            hud.detailsLabelText = title
            hud.hide(true, afterDelay: seconds)
            hud.isUserInteractionEnabled = !underlyingViewsEnabled
            hud.completionBlock = {[weak self] in
                self?.tdw_autoHideHud = nil
            }
        }else {
            let hud = MBProgressHUD.init(view: self)
            guard let hud2 = hud else {
                return
            }
            self.tdw_autoHideHud = hud2
            hud2.isUserInteractionEnabled = !underlyingViewsEnabled
            hud2.mode = MBProgressHUDMode.text
            hud2.detailsLabelText = title;
            hud2.margin = 15
            hud2.cornerRadius = 8.0
            hud2.detailsLabelFont = .systemFont(ofSize: 15)
            hud2.removeFromSuperViewOnHide = true;
            self.addSubview(hud2)
            hud2.show(true)
            hud2.hide(true, afterDelay: seconds)
            hud2.completionBlock = {[weak self] in
                self?.tdw_autoHideHud = nil
            }
        }
    }
    
}

extension UIView {
    
    private struct LoadingAssociatedKeys {
        static var key_loading = "key_loading"
        static var key_autoHideHud = "key_autoHideHud"
        static var key_hud = "key_hud"
    }
    
    fileprivate var tdw_loading: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &LoadingAssociatedKeys.key_loading) as? MBProgressHUD
        }
        set {
            objc_setAssociatedObject(self,
                                     &LoadingAssociatedKeys.key_loading,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var tdw_hud: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &LoadingAssociatedKeys.key_hud) as? MBProgressHUD
        }
        set {
            objc_setAssociatedObject(self,
                                     &LoadingAssociatedKeys.key_hud,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var tdw_autoHideHud: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &LoadingAssociatedKeys.key_autoHideHud) as? MBProgressHUD
        }
        set {
            objc_setAssociatedObject(self,
                                     &LoadingAssociatedKeys.key_autoHideHud,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}


