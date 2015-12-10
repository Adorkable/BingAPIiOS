//
//  Bing.swift
//  BingAPI
//
//  Created by Ian on 4/10/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation
import XCTest

import BingAPI

class BingTest: XCTestCase {
    var bing : Bing?
    
    override func setUp() {
        bing = Bing(accountKey: "mHl8iFbnt0J35H8vNKLnXkXzV/00MmQqo5P7sf1S7HQ=")

        XCTAssertNotNil(Bing.baseUrl, "Base URL is malformed")
        NSURLRequest.setAllowsAnyHTTPSCertificate(true, forHost: Bing.baseUrl!.host)
        
        self.continueAfterFailure = false
    }
    
    func testInit() {
        XCTAssertNotNil(self.bing, "Bing instance should not nil")
    }

    func testSearch() {
        
        let expect = self.expectationWithDescription("Search")
        let timeoutInterval = Bing.timeoutInterval
        
        bing!.search("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (result) -> Void in
            
            switch result {
            case .Success(let results):
                XCTAssertGreaterThan(results.count, 0, "Returned More than Zero Results")
                expect.fulfill()
                break
                
            case .Failure(let error):
                XCTFail("Failure: \(error)")
                break
            }
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
    
    func testSearchSuggest() {
        let expect = self.expectationWithDescription("Search Suggest")
        let timeoutInterval = Bing.timeoutInterval
        
        bing!.searchSuggest("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (result) -> Void in
            
            switch result {
            case .Success(let results):
                XCTAssertGreaterThan(results.count, 0, "Returned More than Zero Results")
                expect.fulfill()
                break
                
            case .Failure(let error):
                XCTFail("Failure: \(error)")
                break
            }
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
}
