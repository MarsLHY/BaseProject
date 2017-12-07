//
//  TDWUserDefaultsHelper.swift
//  TDWPayBack
//
//  Created by lihaiyan on 2017/12/5.
//  Copyright © 2017年 tuandai. All rights reserved.
//

import Foundation

class TDWUserDefautsHelper {
    
    static func saveObject(_ object: Any?, key: String){
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getObject(_ key: String) -> Any?{
        return UserDefaults.standard.object(forKey:key)
    }
    
    static func removeObject(forkey key: String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func removeObjects(forkeys keys: [String]){
        for key in keys {
            removeObject(forkey: key)
        }
    }
}
