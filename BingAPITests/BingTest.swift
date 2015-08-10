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
    }
    
    func testInit() {
        XCTAssertNotNil(self.bing, "Bing instance should not nil")
    }

    func testSearch() {
        
        var expect = self.expectationWithDescription("Search")
        var timeoutInterval = NSTimeInterval(30)
        
        bing!.search("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (results, error) -> Void in
            XCTAssertTrue(results != nil, "Returned Results Array")
            XCTAssertGreaterThan(results!.count, 0, "Returned More than Zero Results")
            XCTAssertNil(error, "Error should be nil: \(error)")
            
            expect.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
    
    func testSearchSuggest() {
        var expect = self.expectationWithDescription("Search Suggest")
        var timeoutInterval = NSTimeInterval(30)
        
        bing!.searchSuggest("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (results, error) -> Void in
            XCTAssertTrue(results != nil, "Returned Results Array")
            XCTAssertGreaterThan(results!.count, 0, "Returned More than Zero Results")
            XCTAssertTrue(error == nil, "No Errors")
            
            expect.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
}
