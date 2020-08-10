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
        let x = d.sorted{$0<$1}.map{$0}
        
        
        var list = ["a","b","c","d","e","f","g"]
        list[4...6] = ["5","6"]
        print(list)
        //fizzBuzz(n: 20)
        return true
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

