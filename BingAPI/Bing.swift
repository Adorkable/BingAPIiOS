//
//  Bing.swift
//  Bing
//
//  Created by Ian on 4/3/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

// https://datamarket.azure.com/dataset/bing/search#schema

public class Bing: NSObject {
    public static let baseUrl = NSURL(string: "https://api.datamarket.azure.com")
    
    public let accountKey : String
    
    public var cachePolicy : NSURLRequestCachePolicy = NSURLRequestCachePolicy.ReloadRevalidatingCacheData
    
    public init(accountKey : String) {
        self.accountKey = accountKey
        
        super.init()
    }
    
    internal func authorizationHeaderValue() -> String? {
        var result : String?
        
        var loginString = self.accountKey + ":" + self.accountKey
        
        if let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        {
            let encodedLoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
            result = "Basic " + encodedLoginString
        }

        return result
    }
    
    internal class func encodeSearchQuery(query : String) -> String?
    {
        var result : String?
        
        if let queryEncoded = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        {
            result = "\'" + queryEncoded + "\'"
        }
        
        return result
    }
    
    internal func configureUrlRequestHandler() -> ( (NSMutableURLRequest) -> Void) {
        return { (urlRequest : NSMutableURLRequest) -> Void in
            if let authorizationHeaderValue = self.authorizationHeaderValue()
            {
                urlRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
            } else
            {
                // TODO: report back to creator
                NSLog("Error configuring Url request with correct authorization")
            }
        }
    }
    
    public func search(searchText : String, timeoutInterval : NSTimeInterval, resultsHandler : ( (results : Array<BingSearchResult>?, error : NSError?) -> Void) ) -> Void {
        
        let searchRoute = SearchRoute(searchText: searchText, timeoutInterval: timeoutInterval, cachePolicy: self.cachePolicy)

        searchRoute.start(self.configureUrlRequestHandler(), resultsHandler: resultsHandler)
    }
}
