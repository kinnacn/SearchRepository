//
//  RepositoriesViewControllerUITests.swift
//  SearchRepositoryUITests
//
//  Created by seibin on 2020/08/29.
//  Copyright © 2020年 seibin. All rights reserved.
//

import XCTest
@testable import SearchRepository

class RepositoriesViewControllerUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // リポジトリの検索画面
    func testSearchRepositoriesScene() {
        
        let app = XCUIApplication()
        // 検索バーある
        let keywordSearchBar = app.otherElements["keywordSearchBar"]
        XCTAssert(keywordSearchBar.exists)
        
        // テーブルがある
        let repositoriesTableview = app.tables["repositoriesTableview"]
        XCTAssert(repositoriesTableview.exists)
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
