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
    
    override func setUp() {
        NSURLRequest.setAllowsAnyHTTPSCertificate(true, forHost: Bing.host)
    }

    func testSearch() {
        var bing : Bing = Bing(accountKey: "mHl8iFbnt0J35H8vNKLnXkXzV/00MmQqo5P7sf1S7HQ=")
        
        var expect = self.expectationWithDescription("Search")
        var timeoutInterval = NSTimeInterval(30)
        
        bing.search("xbox", timeoutInterval: timeoutInterval, resultsHandler: { (results, error) -> Void in
            XCTAssertTrue(results != nil, "Returned Results Array")
            XCTAssertGreaterThan(results!.count, 0, "Returned More than Zero Results")
            XCTAssertTrue(error == nil, "No Errors")
            
            expect.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
}
