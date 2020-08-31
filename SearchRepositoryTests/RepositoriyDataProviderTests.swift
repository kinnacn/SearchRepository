//
//  RepositoriyDataProviderTests.swift
//  SearchRepositoryTests
//
//  Created by seibin on 2020/08/29.
//  Copyright © 2020年 seibin. All rights reserved.
//

import XCTest
@testable import SearchRepository

class RepositoriyDataProviderTests: XCTestCase {
    private let repositoriyDataProvider = RepositoriyDataProvider()    
    private var repositoriyExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        repositoriyDataProvider.delegate = self
        repositoriyExpectation = expectation(description: "Repositoriy")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRepositoriesWithKeyWord() {
        repositoriyDataProvider.getRepositoryInfos("swift")
        waitForExpectations(timeout: 120)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension RepositoriyDataProviderTests: RepositoriyDataProviderDelegate {
    func successGetRepositoriyInfos(_ infos: [[String: Any]]) {
        print(infos)
        repositoriyExpectation?.fulfill()
    }
    
    func failureGetRepositoriyInfos(_ error: Error?) {
        print(error)
        repositoriyExpectation?.fulfill()
    }
}
