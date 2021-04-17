//
//  TJTimeZoneViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/4/17.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit

class TJTimeZoneViewController: TJBaseViewController {
    let group1:DispatchGroup = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 1)
    var testNumber = 1
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        2021-04-17 05:22:59 +0000
//          - timeIntervalSinceReferenceDate : 640329779.341699
        let dateFormate = DateFormatter()
        let timezone1 = TimeZone.current.abbreviation()
        let timezone2 = TimeZone.autoupdatingCurrent.abbreviation()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormate.timeZone = TimeZone.init(abbreviation: "GMT+2")
        let date = Date()
        print(date)
        let dateStr = dateFormate.string(from: date)
        print(dateStr)
        
        let date1 = dateFormate.date(from: dateStr)
        print(date1 ?? "")
        //testGroup3()
        testSemaphore1()
    }
    func testSemaphore1() {
        let queue1:DispatchQueue = DispatchQueue.global()
        let a = [1,2,3,4,5,6,7,8,9,10]
        let lock = NSLock()
        queue1.async {
            for i in a {
                //self.semaphore.wait()
                lock.lock()
                self.testNumber = self.testNumber + 1
                NSLog("1:\(Thread.current)--\(i)-\(self.testNumber)")
                lock.unlock()
                //self.semaphore.signal()
            }
        }
        
        queue1.async {
            for i in a {
                //self.semaphore.wait()
                lock.lock()
                self.testNumber = self.testNumber + 1
                NSLog("1:\(Thread.current)--\(i)-\(self.testNumber)")
                lock.unlock()
                //self.semaphore.signal()
            }
        }

        queue1.async {
            for i in a {
                //self.semaphore.wait()
                lock.lock()
                self.testNumber = self.testNumber + 1
                NSLog("1:\(Thread.current)--\(i)-\(self.testNumber)")
                lock.unlock()
                //self.semaphore.signal()
            }
        }
        print("log")
    }
    func testSemaphore() {
        let a = [1,2,3,4,5,6,7,8,9,10]
        let queue1:DispatchQueue = DispatchQueue.global()
       // self.semaphore.wait()
        queue1.async (group: group1) {
            //self.semaphore.wait()
            for i in a {
               //Thread.sleep(forTimeInterval: 1)
               print("1:\(Thread.current)--\(i)")
            }
            //self.semaphore.signal()
        }
       // self.semaphore.wait()
        queue1.async (group: group1) {
            //self.semaphore.wait()
            for i in a {
               //Thread.sleep(forTimeInterval: 1)
               print("2:\(Thread.current)--\(i)")
            }
            //self.semaphore.signal()
        }
        
        //self.semaphore.wait()
        queue1.async (group: group1) {
            //self.semaphore.wait()
            for i in a {
               //Thread.sleep(forTimeInterval: 1)
               print("3:\(Thread.current)--\(i)")
            }
            //self.semaphore.signal()
        }
        
        group1.notify(queue: queue1, work: DispatchWorkItem(block: {
            print("notify")
        }))
    }
    
    func testGroup3() {
        let queue1:DispatchQueue = DispatchQueue.global()
        queue1.async(group: group1, execute: DispatchWorkItem(block: {
            self.request { (su) in
                print("1s")
            } fail: { (fa) in
                print("1f")
            }
        }))
        
        queue1.async(group: group1, execute: DispatchWorkItem(block: {
            self.request { (su) in
                print("2s")
            } fail: { (fa) in
                print("2f")
            }
        }))
        
        queue1.async(group: group1, execute: DispatchWorkItem(block: {
            self.request { (su) in
                print("3s")
            } fail: { (fa) in
                print("3f")
            }
        }))
        
        group1.notify(queue: DispatchQueue.main) {
            print("notify")
        }
    }
    
    func testGroup2() {
        let queue1:DispatchQueue = DispatchQueue.global()
        queue1.async (group: group1){
            self.request { (su) in
                print("1s")
            } fail: { (fa) in
                print("1f")
            }
        }
        
        queue1.async (group: group1){
            self.request { (su) in
                print("2s")
            } fail: { (fa) in
                print("2f")
            }
        }
        
        queue1.async (group: group1){
            self.request { (su) in
                print("3s")
            } fail: { (fa) in
                print("3f")
            }
        }
        
        group1.notify(queue: DispatchQueue.main) {
            print("notify")
        }
    }
    
    func request(success: @escaping (String) -> Void, fail: @escaping (String) -> Void) {
        let queue1:DispatchQueue = DispatchQueue.global()
        Thread.sleep(forTimeInterval: 3)
        let number1 = arc4random()
        if number1 % 2 == 1 {
            success("success")
        } else {
            fail("fail")
        }
    }
    
    func testGroup1() {
        let queue1:DispatchQueue = DispatchQueue.global()
        //let queue1:DispatchQueue = DispatchQueue.init(label: "textQueue1")
        let queue2:DispatchQueue = DispatchQueue.init(label: "textQueue2")
        let queue3:DispatchQueue = DispatchQueue.init(label: "textQueue3")
                // 队列queue加入队列组
        let a = [1,2,3,4,5,6,7,8,9,10]
        queue1.async (group: group1){
            for i in a {
               Thread.sleep(forTimeInterval: 1)
               print("1:\(Thread.current)--\(i)")
            }
        }
        queue1.async (group: group1){
            for i in a {
               Thread.sleep(forTimeInterval: 1)
               print("2:\(Thread.current)--\(i)")
            }
        }
        queue1.async (group: group1){
            for i in a {
               Thread.sleep(forTimeInterval: 1)
               print("3:\(Thread.current)--\(i)")
            }
        }
                
        /*三个异步任务完成后执行界面处理操作*/
        group1.notify(queue: DispatchQueue.main) {
            print("notify")
        }
    }
}
