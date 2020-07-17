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
       let a = minCost(withAllCostOption: [[1,2,3],[4,3,4],[2,4,1],[1,1,3],[7,4,5],[4,5,6]])
        print(a)
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
    
    func minCost(withAllCostOption cost: [[Int]]) -> Int {
        if cost.count < 1 || cost.count > 100 {
          return -1
        }
        var preMin = min(numbers: cost[0])
        if preMin == -1 {
            return -1
        }
        var minTotalCost = preMin;
        for perCost in cost[1..<cost.count] {
           let minCount = min(numbers:perCost, preMin: preMin)
            if minCount == -1 {
                return -1
            }
            
            minTotalCost = minCount + minTotalCost
            preMin = minCount
            print(preMin)
        }
        return minTotalCost
    }
    
    func min(numbers:[Int],preMin:Int) -> Int {
        if numbers.count != 3 {
            return -1;
        } else {
            var shouldMin = min(numbers: numbers)
            if shouldMin == preMin {
                var muteNumberS = numbers
                if let index = muteNumberS.index(of:preMin) {
                    muteNumberS.remove(at: index)
                    shouldMin = min(numbers: muteNumberS)
                    
                    if let index = muteNumberS.index(of:preMin) {
                       muteNumberS.remove(at: index)
                       shouldMin = min(numbers: muteNumberS)
                    }
                }
            }
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

