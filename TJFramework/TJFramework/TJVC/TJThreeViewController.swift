//
//  TJThreeViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/19.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class WeatherResponse: Mappable {
    var location: String?
    var threeDayForecast: [Forecast]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}
class User: Mappable {
    /*
     SKUList = "<null>";
     actplanversion = "";
     subordinates =     (
     );
     canUseApp =     (
         sc
     );
     monthList =     (
         1,
         2,
         3
     );
     */
    var skuList: String?
    var actPlanVersion: String?
    var subordinates: [Any]?
    var monthList: [String]?
    var canUseApp: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        skuList <- map["SKUList"]
        actPlanVersion <- map["actplanversion"]
        subordinates <- map["subordinates"]
        monthList <- map["monthList"]
        canUseApp <- map["canUseApp"]
    }
}
class TJThreeViewController: TJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        let b = self.block(number: 3) { (a) in
            a * a
        }
        print("bbbb\(b)")
        
        //beginService()
    }
    
    func beginService() {
        /*
         ["resultData": {
             SKUList = "<null>";
             actplanversion = "";
             bpmonthList =     (
             );
             bptoolinfo = "<null>";
             canUseApp =     (
                 sc
             );
             conceptversion = "";
             department = rx;
             docversion = "";
             hospversion = "";
             monthList =     (
                 1,
                 2,
                 3
             );
             mudId = XC134054;
             prodList =     (
             );
             roleId = "";
             roleName = REP;
             ruleSeq = 0;
             rxyear = 2020;
             subordinates =     (
             );
             ta = VOL;
             territoryId = "VOL_MR_HUN20001";
             userName = "\U9648\U5c0f\U534e";
             vxyear = 2020;
             year = 2020;
         }, "statusCode": 100, "statusMessage": success, "detailversion": , "bpversion": 4942, "version": 1597]
         (
             sc
         )
         */
        let param = ["module":"login","mudid":"XC134054","tokenId":"test mode"];
        TJService.postRequestWithParam(param) { (response, result) in
            if (result == .success) {
                if let dic = response,let tokenId = dic["statusMessage"],let t = tokenId as? String {
                    let param1 = ["module":"getuserinfo","mudid":"XC134054","tokenId":t, "isOffline":"N"];
                    TJService.requestWithParam(param1, method: .post) { (response1, result1) in
                        if result1 == .success,let dic1 = response1?["resultData"],let data = dic1 as? [String:Any] {
                            let user = User(JSON: data)
                            print(user ?? "")
                            let canUseApps = data["canUseApp"]
                            print(canUseApps ?? "null")
                        }
                    }
                }
            }
        }
    }
    //54321
    func bubbleSort(originalArray:inout [Int]) -> [Int] {
        let count = originalArray.count
        for i in 0...count - 2 {
            var isChanged = false
            let end = count - i - 2
            for j in 0...end {
                if originalArray[j] > originalArray[j+1] {
                    isChanged = true
                    (originalArray[j],originalArray[j+1]) = (originalArray[j+1],originalArray[j])
                }
            }
            if isChanged == false {
               break
            }
        }
        return originalArray
    }
    
    func block(number:Int, multi:@escaping(Int) -> Int) -> Int{
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
           let q = multi(number)
           print("mmmmm\(q)")
        }
        return number
    }

    func drillMapper() {
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/2ee8f34d21e8febfdefb2b3a403f18a43818d70a/sample_keypath_json"
        Alamofire.request(URL).responseObject(keyPath: "data") { (response: DataResponse<WeatherResponse>) in

            let weatherResponse = response.result.value
            print(weatherResponse?.location ?? "")

            if let threeDayForecast = weatherResponse?.threeDayForecast {
                for forecast in threeDayForecast {
                    print(forecast.day ?? "")
                    print(forecast.temperature ?? "")
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
