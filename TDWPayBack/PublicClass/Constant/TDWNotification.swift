//
//  TDWNotification.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    public struct Login{
        public static let DidLoginIn = Notification.Name(rawValue: "TDWLoginSuccessNotification")
        public static let DidRegistIn = Notification.Name(rawValue: "TDWRegistSuccessNotification")
        public static let DidLogout = Notification.Name(rawValue: "TDWLogoutNotification")
    }
    
    public struct Credit{
        public static let UploadContacts = Notification.Name(rawValue: "TDWUploadContactsNotification")
        public static let CreatOrderSuccess = Notification.Name(rawValue: "TDWCreatOrderSuccessNotification")
    }
    
    public struct Repament{
        public static let repamentSuccess = Notification.Name(rawValue: "TDWRepamentSuccessNotification")//还款成功
    }
}
