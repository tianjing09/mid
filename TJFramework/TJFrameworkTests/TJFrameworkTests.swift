//
//  TJFrameworkTests.swift
//  TJFrameworkTests
//
//  Created by jing 田 on 2018/11/15.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import XCTest
@testable import TJFramework

class TJFrameworkTests: XCTestCase {
    var vc:TJThreeViewController? = nil
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        vc = TJThreeViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vc = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var array = [5,4,3,2,1]
        let result = vc?.bubbleSort(originalArray: &array)
        XCTAssertEqual(result, [1,2,3,4,5], "not pass")
        //XCTAssertEqual(result, [1,1,3,4,5], "not pass")
    }
    
    func testAnother() {
        var array = [5,4,3,2,1]
        let result = vc?.bubbleSort(originalArray: &array)
        XCTAssertEqual(result, [1,2,3,4,5], "not pass")
    }

    func testBlock() {
        var isCall = false
        var re = 0
        vc?.block(number: 3) { (a) in
            re = a * a
            print("ddd",re)
            XCTAssertEqual(re, 9, "not pass")
            isCall = true
        }
        let loopUntil = Date.init(timeIntervalSinceNow: 10)
        while isCall == false && loopUntil.timeIntervalSinceNow > 0 {
            RunLoop.current.run(mode: .default, before: loopUntil)
        }
        if !isCall {
            XCTFail("time out")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            var array = [5,4,3,2,1]
            vc?.bubbleSort(originalArray: &array)
        }
    }

}

