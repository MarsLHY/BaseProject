//
//  TripleDES.h
//  PrivateEquity
//
//  Created by Andy Lee on 26/07/2017.
//  Copyright © 2017 TDW.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleDES : NSObject

/**
 3DES 加密解密类
 TripleDES加密方法
 -- str 所需要加密的字符串
 -- key 加密用到的Key
 返回加密后的字符串，Base64 位的形式
 */
 + (NSString *)encrypt3DesStr:(NSString *)str withKey:(NSString *)key;
 
/**
 TripleDES解密方法
 -- str 所需要解密的字符串，Base64 位的字符串
 -- key 解密用到的Key
 返回解密后的字符串
  */
+ (NSString *)decrypt3DesStr:(NSString	*)str withKey:(NSString *)key;


/**
 TripleDES解密 JSON 字符串，内部实现 JSON 解析
 -- str 所需要解密的字符串，JSON 字段
 -- key 解密用到的Key
 返回数据字典
 */
+ (NSDictionary*)decrypt3DesJson:(NSString*)str withKey:(NSString*)key;

+ (NSString *)createUUID;
@end
