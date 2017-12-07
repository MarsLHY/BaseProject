//
//  RequestParameterPaser.swift
//  PrivateEquity
//
//  Created by Andy Lee on 04/08/2017.
//  Copyright © 2017 TDW.CN. All rights reserved.
//

import Foundation
import SwiftyJSON

var tempKey: String?

private let kPrivateKey_online = "MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEApacsSNozmrIHqtSgFEXpO5cqaeDpT2QOQMvP5KeJtrmuP7y2P9R5b+nGkjAOXq5E64nFOFUXalQlpQCU0kwu9QIDAQABAkA28g5kU8wOIcMdTM2UK+RC2c89s1Zv+PYpU/EvHMs3CjMcRyNf9/TFxNE3XJIalVoxbPSiDMkwDScpAqHk2/c5AiEA11oIg20u2IAdBpl1oP+MTbebRFftS7zW7XXLqrlIj9sCIQDE66jxtWzhVaAOzVh/zNmZ2i4qxxezODav1TZXLb4dbwIgK5GIhWZygtSwiqRDexYYgaSy4gnT9W24IgSh9uFTf98CIQCNag8xRXCjgbIn7x+W561850owPjmu4rejHiKgCKF20QIhANNoWAX3/t7Mg5xXagwAHeCD6EHIBohYd0w5ZKhCxF5G"
private let kPublicKey_online = "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAL6kR5I8QkeryLpz0ORKFGAGyxE1kG4b66DDuEwBcCc6r8DfYku8R7oyd2qMDn/GKjUxd2P54+Mb/Z07L37Fp5ECAwEAAQ=="

private let kPrivateKey_test = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMYC6ECqZv8VlIExd6q1Shis7VzZWflOV6dlqw0XFpqbbUwNNkLvgTN/QiHueBmbMvvfKB+6dSIbgdVleRnDb2UCYn5Dn8UynzOEl5oufQDUf3q61sgwzyZGS98UahplHs6PhoVW43884uk9nWGGISTmOL5MdcAugMI9D+Y0isLlAgMBAAECgYEApxEG4qCjnC+aB9Mz811Yci9dagydBGMcQ8ndI4NKeBIRiqxPDvTDHy8NHlH1FS3EO40SborEj42D4wflwF4L2kIxFRAypfuQLiJS/EAtOR/luwhcAaWaAjooRpgN7x0QMxd6hlwY8w2QOt0Ega+8L7xhUY9lxkUDECNWojOANqECQQDuqNG/v1WcsaauL4cq/QaaRt1Q+W//Fhlt4+QFDkoCJ4mOmjoDMwspbPfosr+7wYgF0DY8m+sCPg9bEC+/K32dAkEA1GYDh4DLX5Vm3L57B1hSk2BPdT+4pGllkYJQz11DKD282ZAfPWoO1MErP47V3UqEhF1fyOPGNL2aYphITZd76QJAIRzxRT6B3WTUsJRNl8xVjzBH4sVJIcZqLtIQwBbUc+oSbuO9KtZ5NP02hGXQrndSrSPPcqdbewsrTEI5rbeWDQJBAIuGE+1wWqiIcRCzBAh4KY5sZuXjnPxLzA/A5irB3frSS3szpIHoaKOz3SAcSTrb159H40MI9Uvx/TelR2HJD/kCQEsuREeuUNxspUUk2x4sP0w7A51VuExnBg2Cmk5kx6yykbNxdp5zCK0S3CCSrtKXwAx7vDjUUSpdqiICQJj65bc="
private let kPublicKey_test = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDOmHrkwqVRaARXWImTdyjcRzHkYCG5135TyJabPgzxPcGVaalnG7j2jjUn5VM9xFo7H+vln4gY/POQl1qXEOEvVi5kKNiJ6kg44937Lhn+nbphHd7BnvT6qAGaR+wfoyYawMvDt+h1xp42mTY9Ww6XMfBt2VBUuoA52FwfYTbe5wIDAQAB"


private let kPrivateKey: String = { () -> String in
    
    switch appEnvironment {
    case .test:
        return kPrivateKey_test
    case .preProduction, .production:
        return kPrivateKey_online
    }
}()

private let kPublicKey: String = { () -> String in
    
    switch appEnvironment {
    case .test:
        return kPublicKey_test
    case .preProduction, .production:
        return kPublicKey_online
    }
}()

class ParameterPaser {
    
    /**
     3DES 加密请求参数
     -- parameter API 请求参数，JSON 格式化成 String
     */
    private func tripleData(_ parameter: String) -> String {
        if tempKey == nil {
            tempKey = TripleDES.createUUID()
        }
        return TripleDES.encrypt3DesStr(parameter, withKey: tempKey)
    }
    
    /**
     RSA 公钥加密 3DES Key（暂时写死，服务器如果需要修改根据服务器修改）
     */
    private func rsaTriple() -> String {
        if tempKey == nil {
            tempKey = TripleDES.createUUID()
        }
        return RSA.encryptString(tempKey, publicKey: kPublicKey)
    }
    
    /**
     RSA 私钥签名请求数据
     */
    private func rsaSign(_ tripleData: String) -> String {
        let sign = self.rsaTriple() + "&" + self.tripleData(tripleData)
        let signBase = RSA.sign(sign.data(using: .utf8), privateKey: kPrivateKey)
        return signBase!.base64EncodedString()
    }
    
    /**
     请求参数签名以及服务服务端所需的格式，返回的是 Dictionary 格式
     -- parameter API 请求参数，JSON 格式化成 String
     */
    public func paseParameter(_ parameter: JSON) -> [String: Any] {
        
        let tripleData = self.tripleData(parameter.description)
        let key = self.rsaTriple()
        let sign = self.rsaSign(parameter.description)
        
        let requestBody = ["data": tripleData, "key": key, "sign": sign]
        return requestBody
    }
    
    /**
     解密数据返回，返回 JSON 格式
     -- parameter 服务端返回加密数据，用 kTripleKey 解密
     */
    public func parseResponse(_ response: Data) -> JSON {
        
        let tempData = JSON(data:response).dictionary
        guard tempData != nil else {
            print("数据返回为空")
            return JSON([:])
        }
        
        // 验签
//        let sign = tempData!["sign"]
//        let key = tempData!["key"]
//        let data = tempData!["data"]
//        
//        let keyDataStr = ((key?.rawString() ?? "") + "&" + (data?.rawString() ?? ""))
//        let signStr = (sign?.rawString() ?? "")
//
//        let signData = signStr.data(using: .utf8)
//        let keyData = keyDataStr.data(using: .utf8)
//        if signData != nil && keyData != nil {
//            let verifyResult = RSA.verifyData(keyData, sign: signData, publicKey: kPublicKey)
//            print("\(verifyResult)=====")
//        }
        
        let responseData = JSON(data:response)
        let respondKey:String = RSA.decryptString(responseData["key"].stringValue, privateKey: kPrivateKey)
        let decrypt = TripleDES.decrypt3DesStr(responseData["data"].description, withKey: respondKey)
        if let decrypt = decrypt {
            return JSON(parseJSON: decrypt)
        }else{
            // 解密失败
            print("解密失败")
        }
        return JSON([:])
    }
}
