//
//  HeroesTests.swift
//  HeroesTests
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import XCTest
@testable import Heroes

class HeroesTests: XCTestCase {
    
    let hereosViewController = HereosListViewController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCollectionHasItems() {
        
        let expectation = self.expectation(description: "longRunningFunction")
        
        hereosViewController.testLoadingNewHereos() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { [unowned self] error in
            XCTAssertGreaterThan(self.hereosViewController.hereos.count, 0, "Hereos' list is empty!")
        }
    }
    
}


