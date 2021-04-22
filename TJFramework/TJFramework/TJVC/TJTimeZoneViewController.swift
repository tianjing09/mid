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
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormate.timeZone = TimeZone.init(abbreviation: "GMT+2")
        let date = Date()
        print(date)
        let dateStr = dateFormate.string(from: date)
        print(dateStr)
        //dateFormate.timeZone = TimeZone.current
        let date1 = dateFormate.date(from: dateStr)
        print(date1 ?? "")
        
        print(convertDate(date: Date()))
//        testGroup3(name: "11")
//        testGroup3(name: "22")
//        testGroup3(name: "33")
        
        testGroup4(name: "11")
        testGroup4(name: "22")
        testGroup4(name: "33")
        
        //testSemaphore1()
       
    }
    func convertDate(date: Date, from sourceTimeZone: TimeZone = TimeZone.init(secondsFromGMT: 0)!, to destinationTimeZone: TimeZone = TimeZone.current) -> Date {
        
        let sourceGMTOffset = sourceTimeZone.secondsFromGMT(for: date)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: date)
        let interval = destinationGMTOffset - sourceGMTOffset
        let destinationDateNow = Date(timeInterval: TimeInterval(interval), since: date)
        
        return destinationDateNow
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
    func testGroup4(name: String) {
        var a = 0
        let group: DispatchGroup = DispatchGroup()
        let lock = NSLock()
        let queue1:DispatchQueue = DispatchQueue.global(qos: .utility)
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            print("\(name)--w1")
            
            let sh = DispatchSemaphore(value: 0)
            self.request { (su) in
                lock.lock()
                a = a + 1
                print("\(name)--1s--\(a)")
                lock.unlock()
               
                sh.signal()
            } fail: { (fa) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--1f--\(a)")
                lock.unlock()
               
                sh.signal()
            }
            print("\(name)--b1")
            sh.wait()
            print("\(name)--t1")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            let sh = DispatchSemaphore(value: 0)
            print("\(name)--w2")
           
            self.request { (su) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--2s--\(a)")
                lock.unlock()
                
                sh.signal()
            } fail: { (fa) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--2f--\(a)")
                lock.unlock()
                
                sh.signal()
            }
            print("\(name)--b2")
            sh.wait()
            print("\(name)--t2")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            let sh = DispatchSemaphore(value: 0)
            print("\(name)--w3")
            self.request { (su) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--3s--\(a)")
                lock.unlock()
                
                sh.signal()
            } fail: { (fa) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--3f--\(a)")
                lock.unlock()
               
                sh.signal()
            }
            print("\(name)--b3")
            sh.wait()
            print("\(name)--t3")
        }))
        
        group.notify(queue: DispatchQueue.main) {
            print("\(name)--notify--\(a)")
        }
    }
     
    func testGroup3(name: String) {
        var a = 0
        let group: DispatchGroup = DispatchGroup()
        let lock = NSLock()
        let queue1:DispatchQueue = DispatchQueue.global(qos: .utility)
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            print("\(name)--w1")
            group.enter()
           
            self.request { (su) in
                lock.lock()
                a = a + 1
                print("\(name)--1s--\(a)")
                lock.unlock()
                group.leave()
                //sh.signal()
            } fail: { (fa) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--1f--\(a)")
                lock.unlock()
                group.leave()
                //sh.signal()
            }
            print("\(name)--b1")
            //sh.wait()
            print("\(name)--t1")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
        
            print("\(name)--w2")
            group.enter()
            self.request { (su) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--2s--\(a)")
                lock.unlock()
                group.leave()
                //sh.signal()
            } fail: { (fa) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--2f--\(a)")
                lock.unlock()
                group.leave()
                //sh.signal()
            }
            print("\(name)--b2")
            //sh.wait()
            print("\(name)--t2")
        }))
        
        queue1.async(group: group, execute: DispatchWorkItem(block: {
            
            print("\(name)--w3")
            group.enter()
            self.request { (su) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--3s--\(a)")
                lock.unlock()
                group.leave()
                //sh.signal()
            } fail: { (fa) in
                lock.lock()
                a = a + 1
                //lock.unlock()
                print("\(name)--3f--\(a)")
                lock.unlock()
                group.leave()
                //sh.signal()
            }
            print("\(name)--b3")
            //sh.wait()
            print("\(name)--t3")
        }))
        
        group.notify(queue: DispatchQueue.main) {
            print("\(name)--notify--\(a)")
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
        queue1.async {
            Thread.sleep(forTimeInterval: 3)
            let number1 = arc4random()
            if number1 % 2 == 1 {
                success("success")
            } else {
                fail("fail")
            }
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
