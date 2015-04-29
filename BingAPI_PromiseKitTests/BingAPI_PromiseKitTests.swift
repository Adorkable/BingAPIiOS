//
//  BingAPI_PromiseKitTests.swift
//  BingAPI_PromiseKitTests
//
//  Created by Ian on 4/29/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import UIKit
import XCTest

import BingAPI
import PromiseKit
import BingAPI_PromiseKit

class BingAPI_PromiseKitTests: XCTestCase {
    
    func testSearch() {
        // To get test to run please replace Account Key
        var bing : Bing = Bing(accountKey: "TIVypj7BfPDAGOjysT5CleluQIAeA4tJMslX4+qpHDY=") // <#Account Key#>)
        
        var expect = self.expectationWithDescription("Search")
        var timeoutInterval = NSTimeInterval(30)
        
        var promise = bing.promiseSearch("xbox", cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        promise.then(onQueue: dispatch_get_main_queue(), body: { (results : Array<BingSearchResult>?) -> Promise< Array<BingSearchResult>? >? in
            XCTAssertTrue(results != nil, "Returned Results Array")
            XCTAssertGreaterThan(results!.count, 0, "Returned More than Zero Results")
            
            expect.fulfill()
            return nil
        })
        
        promise.catch(onQueue: dispatch_get_main_queue(), body: { (error : NSError) -> Void in
            XCTAssertTrue(false, "No Errors")
        })
        
        self.waitForExpectationsWithTimeout(timeoutInterval, handler: nil)
    }
}
