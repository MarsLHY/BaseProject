//
//  TDWUserManager.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation
import RealmSwift

protocol TDWUserProtocol {
    ///用户id
    var userId: String? {get}
    ///token
    var token: String?  {get}
    ///头像
    var headImage:String? {get}
    ///用户名
    var userName:String?  {get}
    ///手机号
    var telNo:String?  {get}
    ///消息推送设置
    var messageNotification: Bool {get}
    ///登录状态
    var isLogin: Bool {get}
    ///上次登录时间
    var preLoginTime: String? {get}
    ///之前是否登录过
    var hasLoginedBefore: Bool {get}
}

//更新属性
protocol TDWUserUpdateProtocol: class {
    var headImage: String? {get set}
    var userName: String? {get set}
    var telNo: String? {get set}
    var messageNotification: Bool {get set}
}

//新增Key的时候用
protocol TDWUserAddProtocol: class {
    var userId: String? {get set}
    var token: String? {get set}
    var telNo: String? {get set}
    var isLogin: Bool {get set}
    var preLoginTime: String? {get set}
    var messageNotification: Bool {get set}
}

class TDWUserManager: NSObject {
    
    static let shared = TDWUserManager()
    private override init() {}
    private var realUser: TDWUser = TDWUser()
    
    var user: TDWUserProtocol { return realUser }
    
    ///MARK: 从Real中读取缓存的用户信息
    func cacheUserFromRealm() {
        /// 版本更新 0为最新版本号
        /// MARK: 每次修改字段都要自增版本号！realm会自动更新数据库文件中的字段
        updateUserDBVersion(0)
        
        if let realm = try? Realm() {
            let userInfo = realm.objects(TDWUser.self).filter({ (userDB) -> Bool in
                return userDB.isLogin
            }).first
            if let userInfo = userInfo  {
                realUser = userInfo
            }
        }
    }
    
    //是否登录
    var isLogin: Bool {
        
        /// 逻辑
        if realUser.userId == nil || realUser.userId!.isEmpty  {
            return false
        }
        if realUser.token == nil || realUser.token!.isEmpty {
            return false
        }
        return true
    }
    
    ///MARK: 更新User---修改用户资料调用这里
    func updateUser(clourse: @escaping (TDWUserUpdateProtocol) -> Void) {
        
        if let realm = try? Realm() {
            do {
                try realm.write {
                    clourse(self.realUser)
                }
            } catch {
                print("更新用户信息失败")
            }
        }
    }
    ///MARK: 新增User---登录、注册调用这里
    func addUser(clourse: @escaping (TDWUserAddProtocol) -> Void) {
        if let realm = try? Realm() {
            do{
                try realm.write {
                    clourse(self.realUser)
                    realm.add(self.realUser,update: true)
                }
            } catch {
                print("新增用户信息失败")
            }
        }
    }
    ///MARK: 删除用户---退出登录调用这里
    func deleteUser() {
        //必须是登录的
        guard isLogin else {
            return
        }
        
        if let realm = try? Realm() {
            do {
                try realm.write {
                    self.realUser.isLogin = false
                    self.realUser = TDWUser()
                    NotificationCenter.default.post(name: Notification.Name.Login.DidLogout, object: nil)
                }
            } catch {
                print("删除用户信息失败")
            }
        }
    }
    ///MARK: 判断之前是否登录过必须在登录写入数据库之前调用
    func judgeHasLoginedBefore(_ userId: String?) {
        guard userId != nil else {
            return
        }
        if let realm = try? Realm() {
            let userInfo = realm.objects(TDWUser.self).filter({ (userDB) -> Bool in
                return userDB.userId == userId
            }).first
            //之前存在过
            if userInfo != nil {
                self.realUser.hasLoginedBefore = true
            }
        }
    }
    
    
    /// 字段更改版本更新时必须调用
    /// 旧的版本号: 0
    func updateUserDBVersion(_ newVersion: UInt64){
        
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号
            // （如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: newVersion,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < newVersion) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
    }
}

class TDWUser: Object, TDWUserProtocol,TDWUserUpdateProtocol,TDWUserAddProtocol {
    
    dynamic var userId: String?
    dynamic var token: String?
    dynamic var headImage: String?
    dynamic var userName: String?
    dynamic var telNo: String?
    dynamic var messageNotification: Bool = true
    dynamic var isLogin: Bool = false
    dynamic var preLoginTime: String?
    var hasLoginedBefore: Bool = false
    override class func primaryKey() -> String? {
        return "userId"
    }
}


