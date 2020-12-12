//
//  TJFrameworkUITests.swift
//  TJFrameworkUITests
//
//  Created by jing 田 on 2018/11/15.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import XCTest

class TJFrameworkUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["无条件"]/*[[".cells.staticTexts[\"无条件\"]",".staticTexts[\"无条件\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["你曾是少年"]/*[[".cells.staticTexts[\"你曾是少年\"]",".staticTexts[\"你曾是少年\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element4 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1)
        let element = element4.children(matching: .other).element(boundBy: 4)
        element.swipeRight()
        element.swipeRight()
        element.swipeLeft()
        element.swipeRight()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["colorfulBar"]/*[[".cells.staticTexts[\"colorfulBar\"]",".staticTexts[\"colorfulBar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element2 = element.children(matching: .other).element(boundBy: 0)
        element2.tap()
        element2.swipeLeft()
        element2.swipeRight()
        
        let mutiselectStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["mutiSelect"]/*[[".cells.staticTexts[\"mutiSelect\"]",".staticTexts[\"mutiSelect\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mutiselectStaticText.tap()
        
        let alamofireStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["alamofire"]/*[[".cells.staticTexts[\"alamofire\"]",".staticTexts[\"alamofire\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        alamofireStaticText.tap()
        mutiselectStaticText.tap()
        element.swipeLeft()
        element.swipeLeft()
        
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["3"]/*[[".cells.staticTexts[\"3\"]",".staticTexts[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        
        let staticText2 = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["4"]/*[[".cells.staticTexts[\"4\"]",".staticTexts[\"4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText2.tap()
        app.buttons["ok"].tap()
        element.swipeRight()
        alamofireStaticText.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["snapkit"]/*[[".cells.staticTexts[\"snapkit\"]",".staticTexts[\"snapkit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["RxSwift"]/*[[".cells.staticTexts[\"RxSwift\"]",".staticTexts[\"RxSwift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["从前的我"]/*[[".cells.staticTexts[\"从前的我\"]",".staticTexts[\"从前的我\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element.swipeRight()
        mutiselectStaticText.tap()
        element.swipeLeft()
        app.navigationBars["TJFramework.TJStructureView"].buttons["Back"].tap()
        
        let addButton = app.buttons["add"]
        addButton.tap()
        
        let element3 = element4.children(matching: .other).element
        element3.swipeRight()
        addButton.tap()
        element3.children(matching: .other).element(boundBy: 0).swipeRight()
        mutiselectStaticText.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".cells.staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        staticText2.tap()
        staticText.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["5"]/*[[".cells.staticTexts[\"5\"]",".staticTexts[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["ok"]/*[[".buttons[\"ok\"].staticTexts[\"ok\"]",".staticTexts[\"ok\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element4.children(matching: .other).element(boundBy: 1).swipeLeft()
       
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
