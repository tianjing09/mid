//
//  TJService.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/15
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit
import Alamofire

let baseURL = "https://pms-prod.igskapp.com/scorecardadmin/scorecard/webserviceReq"

class TJService: NSObject {
    enum RequestResult {
        case success,fail,paramError,parseError
    }
    
    static func requestWithParam(_ param:[String:Any],method:HTTPMethod, complete:@escaping ([String:Any]?,RequestResult) -> Void) {
        var process = param
        let mudid = param["mudid"]
        let timeStamp = Date.init().timeIntervalSince1970
        process["bpinfo"] = "\(mudid ?? "aa")_\(integer_t(timeStamp))_1.3"
        print("request param:\(process)")
        Alamofire.request(baseURL, method: method, parameters: process).responseData { response in
            print("result param:\(process)")
            if let oData = response.result.value {
                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                let gbString = String(data: oData, encoding: String.Encoding(rawValue: enc))
                if let str = gbString, let data = str.data(using: .utf8) {
                    if let dicc = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        if let process = dicc as? Dictionary<String, Any> {
                            print(process)
                            complete(process,.success)
                        } else {
                            complete(nil,.parseError)
                            print("convert dic fail")
                        }
                    } else {
                        complete(nil,.parseError)
                        print("convert json fail")
                    }
                } else {
                    complete(nil,.fail)
                    print(gbString ?? "convert string fail")
                }
            } else {
                complete(nil,.fail)
            }
        }
    }
    
    static func getRequestWithParam(_ param:[String:Any], complete:@escaping ([String:Any]?,RequestResult) -> Void) {
        TJService.requestWithParam(param, method: .get) { (result, message) in
            complete(result, message)
        }
    }
    
    static func postRequestWithParam(_ param:[String:Any], complete:@escaping ([String:Any]?,RequestResult) -> Void) {
        TJService.requestWithParam(param, method: .post) { (result, message) in
            complete(result, message)
        }
    }
}
