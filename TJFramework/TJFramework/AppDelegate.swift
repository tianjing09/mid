//
//  AppDelegate.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/15.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       //let a = minCost(withAllCostOption: [[3],[4],[21],[18],[7],[4]])
       // print(a)
        let d = ["jo":23,"ja":24]
        let x = d.sorted{$0.1<$1.1}.map{$0.0}
       
        
        var list = ["a","b","c","d","e","f","g"]
        list[4...6] = ["5","6"]
        print(list)
        //fizzBuzz(n: 20)
        
        print(TJMD5.encryptyMD5(with: "tianjing田静"))
        print(TJBase64.encodeToBase64(with: "tianjing田静tianjing田静"))
        print(TJBase64.decode(base64String: "dGlhbmppbmfnlLDpnZl0aWFuamluZ+eUsOmdmQ=="))
        print(TJSHA.sha512(with: "tianjing田静"))
        print(TJSHA.sha256(with: "tianjing田静"))
        jsonToModel()
        jsonToDic()
        let nav = UINavigationController(rootViewController: TJStructureViewController())
        window?.rootViewController = nav
        window?.backgroundColor = .gray
        window?.makeKeyAndVisible()
        return true
    }
    
    func jsonToModel() {
        let jsonString = """
        {
            "name": "Kody",
            "className": "Swift",
            "courceCycle": 10,
            "personInfo": [
                {
                   "age": 18,
                   "height": 1.85
                },{
                   "age": 20,
                   "height": 1.75
                }
            ]
        }
        """

        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        if let data = jsonData{
            let result = try? decoder.decode(Teacher.self, from: data)
            print(result ?? "解析失败")
        }
    }
    func jsonToDic() {
        let
        jsonstr="{\"status\":\"1\",\"data\":{\"udid\":\"5bce8b974adbc6a60858d41657f1761305f62ce9\",\"time\":\"1580546728\",\"orderid\":\"20200201164519672\"}}"
        let jsondata = jsonstr.data(using: .utf8)


        do {
            let ok =  try JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers) as AnyObject
            
            let status:String=ok["status"] as! String
            
        } catch {
                print(error)
            }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func fizzBuzz(n: Int) -> Void {
        if n < 1 {
            return
        }
        for i in 1...n {
            if i % 3 == 0 && i % 5 == 0 {
                print("FizzBuzz")
            } else if i % 3 == 0 {
                print("Fizz")
            } else if i % 5 == 0 {
                print("Buzz")
            } else {
                print(i)
            }
        }
    }
    
    func minCost(withAllCostOption cost: [[Int]]) -> Int {
        if cost.count < 1 || cost.count > 100 {
          return -1
        }
        let preMin = min(numbers: cost[0])
        print(preMin)
        var minTotalCost = preMin;
        var index = cost[0].index(of: preMin)!
        for perCost in cost[1..<cost.count] {
           let minCount = min(numbers: perCost, preIndex: index)
            if minCount == -1 {
                return -1
            }
           minTotalCost = minCount + minTotalCost
           index = perCost.index(of: minCount)!
           print(minCount)
        }
        return minTotalCost
    }
    
    func min(numbers:[Int],preIndex:Int) -> Int {
        if numbers.count != 3 {
            return -1;
        } else {
            var tempNumbers = numbers;
            tempNumbers.remove(at: preIndex)
            let shouldMin = min(numbers: tempNumbers)
            return shouldMin
        }
    }
    
    func min(numbers:[Int]) -> Int {
        var min = numbers[0];
        for number in numbers[1..<numbers.count] {
            if number < min {
                min = number
            }
        }
        return min
    }

}

