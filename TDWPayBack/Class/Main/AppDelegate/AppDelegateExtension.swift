//
//  AppDelegateExtension.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/4.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import SensorsAnalyticsSDK
import Bugly

extension AppDelegate {
    
    func buildTabbarController() {
        let tabbarController = TDWTabbarController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = tabbarController
        self.window?.makeKeyAndVisible()
    }
    
    func initThirdSDK() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        //Bugly
        //AppID：4c5cc62b88
        //AppKey：be9507d5-5080-4a25-9bbd-e74e9fb04788
        //Bugly.start(withAppId: "4c5cc62b88")
    }
    
    ///MARK: 从Realm缓存用户信息
    func cacheUerFromRealm() {
        TDWUserManager.shared.cacheUserFromRealm()
    }
    
    func initializeSensorsAnalyticsSDK(){
        
    }
    
}


