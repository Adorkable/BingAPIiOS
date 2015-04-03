//
//  BingAPITests.swift
//  BingAPITests
//
//  Created by Ian on 4/3/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import UIKit
import XCTest
import BingAPI

class BingAPITests: XCTestCase {
    // To get test to run please replace Account Key
    var bing : Bing = Bing(accountKey: <#Account Key#>)

    func testSearch() {
        var expect = self.expectationWithDescription("Search")
        var timeoutInterval = NSTimeInterval(30)
        
        bing.search("xbox", cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval, resultsHandler: { (results, error) -> Void in
            XCTAssertTrue(results != nil, "Returned Results Array")
            XCTAssertGreaterThan(results!.count, 0, "Returned More than Zero Results")
            XCTAssertTrue(error == nil, "No Errors")
            
            expect.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
}
