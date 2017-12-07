/*
 @author: ideawu
 @link: https://github.com/ideawu/Objective-C-RSA
*/

#import <Foundation/Foundation.h>

@interface RSA : NSObject

/**
 ## encryptString:publicKey: 用公钥加密数据
 -- str 加密的内容
 -- pubKey 公钥
 返回 Base64 encode 的字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 ## encryptString:privateKey: 用私钥加密数据
 -- str 加密的内容
 -- pubKey 私钥
返回 Base64 encode 的字符串
 */
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;

/**
 ## encryptData:publicKey: 用公钥加密数据
 -- str 加密的内容
 -- pubKey 公钥
 返回 Data 形式数据
 */
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;

/**
 ## encryptString:privateKey: 用公钥加密数据
 -- str 加密的内容
 -- pubKey 公钥
返回 Data 形式数据
 */
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

/**
 ## decryptString:publicKey: 用私钥解密数据
 -- str 加密的内容
 -- pubKey 公钥
 */
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 ## decryptString:publicKey: 用公钥加密数据
 -- str 加密的内容
 -- pubKey 公钥
 */
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;

/**
 ## decryptString:publicKey: 用私钥解密数据
 -- str 加密的内容
 -- pubKey 公钥
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;

/**
 ## decryptString:publicKey: 用私钥解密数据
 -- str 加密的内容
 -- pubKey 公钥
*/
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

/**
 RSA私钥数据签名
 -- data 需要签名的数据
 -- privKey 进行签名的私钥 Base64 形式
 返回RSA签名好的数据内容
 */
+ (NSData *)signData:(NSData *)data privateKey:(NSString *)privKey;

/**
 RSA数据签名验证，验证采用私钥加密的内容是否被篡改过
 -- data 签名之后的数据
 -- publicKey 验证签名钥匙 Base64 形式
 返回BOOL，true 代表是正确的，false 代表被篡改了
*/
+ (BOOL)verifyData:(NSData *)data publicKey:(NSString *)publicKey;

/**
 RSA数据签名验证，验证采用私钥加密的内容是否被篡改过
 -- data 签名之后的数据
 -- publicKey 验证签名钥匙 Base64 形式
 返回BOOL，true 代表是正确的，false 代表被篡改了
 */
+ (BOOL)verifyData:(NSData *)data signData:(NSData *)signData publicKey:(NSString *)publicKey;
@end
