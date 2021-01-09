//
//  TJEncrypt.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/5.
//  Copyright © 2021 jing 田. All rights reserved.
//

import Foundation
import CommonCrypto

class TJRSA {
    
}

class TJBase64 {
    static func encodeToBase64(with string: String) -> String {
        let data = string.data(using: .utf8)
        return data?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? "error base64"
    }
    
    static func decode(base64String:String) -> String {
        guard let data = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions(rawValue: 0)) else { return "error string" }
        return String(data: data, encoding: .utf8) ??  "error string"
    }
}

class TJMD5 {
    class func encryptyMD5(with string: String) -> String {
        let cString = string.cString(using: .utf8)
        let strLength = CUnsignedInt(string.lengthOfBytes(using: .utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_MD5(cString, strLength, result)
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
}

class TJSHA {
    static func sha512(with string: String) -> String {
        let cString = string.cString(using: .utf8)
        let strLength = CUnsignedInt(string.lengthOfBytes(using: .utf8))
        let digestLength = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_SHA512(cString, strLength, result)
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
    
    static func sha256(with string: String) -> String {
        let cString = string.cString(using: .utf8)
        let strLength = CUnsignedInt(string.lengthOfBytes(using: .utf8))
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_SHA256(cString, strLength, result)
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
}

struct Teacher: Codable{
    var name: String
    var className: String
    var courceCycle: Int
    var personInfo: [PersonInfo]
}

extension Teacher {
    struct PersonInfo: Codable {
        var age: Int
        var height: Double
    }
}
