//
//  Bing.swift
//  Bing
//
//  Created by Ian on 4/3/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

import AdorkableAPIBase

// https://datamarket.azure.com/dataset/bing/search#schema
// https://onedrive.live.com/view.aspx?resid=9C9479871FBFA822!110&app=Word&authkey=!AInKSlZ6KEzFE8k

/**
*  Bing API Object
*/
public class Bing: API {

    public static var requestProtocol : String { return "https" }
    public static var domain : String { return "api.datamarket.azure.com" }
    public static var port : String { return "443" }
    
    /// Bing API Instance's account key
    public let accountKey : String
    
    /**
    Main init
    
    :param: accountKey Azure Marketplace API key
    
    */
    public init(accountKey : String) {
        self.accountKey = accountKey
    }
    
    internal func authorizationHeaderValue() -> String? {
        var result : String?
        
        let loginString = self.accountKey + ":" + self.accountKey
        
        if let loginData = loginString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        {
            let encodedLoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
            result = "Basic " + encodedLoginString
        }

        return result
    }
    
    internal class func encodeSearchQuery(query : String) -> String?
    {
        var result : String?
        
        if let queryEncoded = self.encodeString(query)
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
    
    /**
    Get search results
    
    :param: searchText      text to search for
    :param: timeoutInterval request timeout
    :param: resultsHandler  closure for handling results from request
    */
    public func search(searchText : String, timeoutInterval : NSTimeInterval, resultsHandler : SearchRoute.ResultsHandler) {
        
        let searchRoute = SearchRoute(searchText: searchText, timeoutInterval: timeoutInterval, cachePolicy: Bing.cachePolicy)
        searchRoute.start(self.configureUrlRequestHandler(), resultsHandler: resultsHandler)
    }
    
    /**
    Get search suggestion results
    
    :param: searchText      text to search for
    :param: timeoutInterval request timeout
    :param: resultsHandler  closure for handling results from request
    */
    public func searchSuggest(searchText : String, timeoutInterval : NSTimeInterval, resultsHandler : SearchSuggestRoute.ResultsHandler) {
        
        let searchSuggestRoute = SearchSuggestRoute(searchText: searchText, timeoutInterval: timeoutInterval, cachePolicy: Bing.cachePolicy)
        searchSuggestRoute.start(nil, resultsHandler: resultsHandler)
    }
}
