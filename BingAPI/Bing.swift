//
//  Bing.swift
//  Bing
//
//  Created by Ian on 4/3/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

public class Bing: NSObject {
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
    
    internal let searchRoot : String = "https://api.datamarket.azure.com/Bing/Search/Web?$format=json&Query="

    internal class func encodeSearchQuery(query : String) -> String?
    {
        var result : String?
        
        if let queryEncoded = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        {
            result = "\'" + queryEncoded + "\'"
        }
        
        return result
    }
    
    public func search(query : String, timeoutInterval : NSTimeInterval, resultsHandler : ( (results : Array<BingSearchResult>?, error : NSError?) -> Void) ) -> Void {

        if let authorizationHeaderValue = self.authorizationHeaderValue()
        {
            if let queryEncoded = Bing.encodeSearchQuery(query)
            {
                let searchFull = self.searchRoot + queryEncoded

                if let searchURL = NSURL(string: searchFull)
                {
                    var urlRequest = NSMutableURLRequest(URL: searchURL, cachePolicy: self.cachePolicy, timeoutInterval: timeoutInterval)
                    urlRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
                    
                    var urlSession = NSURLSession.sharedSession()
                    var task = urlSession.dataTaskWithRequest(urlRequest, completionHandler:self.searchCompletionHandler(resultsHandler) )
                    task.resume()
                } else
                {
                    resultsHandler(results: [], error: NSError(domain: "Invalid search url " + searchFull, code: 0, userInfo: nil) )
                }
            } else
            {
                resultsHandler(results: [], error: NSError(domain: "Unable to encode query " + query, code: 0, userInfo: nil) )
            }
        } else
        {
            resultsHandler(results: [], error: NSError(domain: "Unable to encode Account Key into authorization header", code: 0, userInfo: nil) )
        }
    }
    
    internal func searchCompletionHandler(resultsHandler : ( (results : Array<BingSearchResult>?, error : NSError?) -> Void) ) -> ((data : NSData?, urlResponse : NSURLResponse?, error : NSError?) -> Void) {
        return { (data : NSData?, urlResponse : NSURLResponse?, error : NSError?) -> Void in
            if data != nil
            {
                var error : NSError?
                if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: &error)
                {
                    if let jsonDictionary = jsonObject as? NSDictionary
                    {
                        var results = self.parseResults(jsonDictionary)
                        resultsHandler(results: results.0, error: results.1)
                    } else
                    {
                        resultsHandler(results: [], error: NSError(domain: "Results in unknown format " + _stdlib_getDemangledTypeName(jsonObject), code: 0, userInfo: nil) )
                    }
                } else if let errorString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
                {
                    resultsHandler(results: [], error: NSError(domain: errorString, code: 0, userInfo: nil) )
                } else
                {
                    resultsHandler(results: [], error: NSError(domain: "Unknown error from request", code: 0, userInfo: nil) )
                }
            } else
            {
                resultsHandler(results: [], error: error)
            }
        }
    }
    
    internal func parseResults(jsonResponse : NSDictionary) -> (Array<BingSearchResult>?, NSError?)
    {
        var result : Array<BingSearchResult>?
        
        if let d = jsonResponse["d"] as? NSDictionary
        {
            if let searchResults = d["results"] as? NSArray
            {
                for searchResultObject in searchResults
                {
                    if let searchResult = searchResultObject as? NSDictionary
                    {
                        if result == nil
                        {
                            result = Array<BingSearchResult>()
                        }
                        result!.append( BingSearchResult(dictionary: searchResult) )
                    }
                }
            }
        }
        
        return (result, nil)
    }
}
