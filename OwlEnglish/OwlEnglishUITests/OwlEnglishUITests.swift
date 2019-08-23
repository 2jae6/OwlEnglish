//
//  OwlEnglishUITests.swift
//  OwlEnglishUITests
//
//  Created by 1 on 03/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import XCTest

class OwlEnglishUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        //XCUIApplication().launch()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        snapshot("1")
        app.navigationBars["단어장"].buttons["Add"].tap()
        snapshot("2")
        app.navigationBars["단어 추가"].buttons["뒤로가기"].tap()
        
        
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["영어로 검색"].tap()
        snapshot("3")
        app.navigationBars["OwlEnglish.View"].buttons["Back"].tap()
        toolbar.buttons["시험 시작"].tap()
        snapshot("4")
        app.navigationBars["OwlEnglish.EnglishExam"].buttons["Back"].tap()
        toolbar.buttons["한글로 검색"].tap()
        snapshot("5")
        app.navigationBars["OwlEnglish.SecondView"].buttons["Back"].tap()
    }

}
