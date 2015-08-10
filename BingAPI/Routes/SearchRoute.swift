//
//  SearchRoute.swift
//  BingAPI
//
//  Created by Ian on 6/12/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

import AdorkableAPIBase

class SearchRoute: RouteBase {
    override internal class var baseUrl : NSURL? {
        return Bing.baseUrl
    }
    
    override internal class var path : String {
        get {
            return "/Bing/Search/Web"
        }
    }
    
    var searchText : String
    
    init(searchText : String, timeoutInterval : NSTimeInterval = RouteBase.defaultTimeout, cachePolicy : NSURLRequestCachePolicy = RouteBase.defaultCachePolicy) {
        self.searchText = searchText
        
        super.init(timeoutInterval: timeoutInterval, cachePolicy: cachePolicy)
    }
    
    override internal var query : String {
        get {
            var result = "$format=json"
            
            if count(self.searchText) > 0
            {
                RouteBase.addParameter(&result, name: "Query", value: "\'\(self.searchText)\'")
            }
            
            return result
        }
    }
    
    func start(configureUrlRequest : (urlRequest : NSMutableURLRequest) -> Void, resultsHandler : ( (results : Array<BingSearchResult>?, error : NSError?) -> Void) ) {
        
        let task = self.jsonTask(configureUrlRequest: configureUrlRequest) { (jsonObject, error) -> Void in
            if let jsonDictionary = jsonObject as? NSDictionary
            {
                var results = self.dynamicType.parseResults(jsonDictionary)
                resultsHandler(results: results.0, error: results.1)
            } else
            {
                resultsHandler(results: [], error: NSError(domain: "Results in unknown format " + _stdlib_getDemangledTypeName(jsonObject), code: 0, userInfo: nil) )
            }
        }
        
        if task != nil
        {
            task!.resume()
        } else
        {
            resultsHandler(results: [], error: NSError(domain: "Unable to create SearchRoute task", code: 0, userInfo: nil) )
        }
    }
    
    internal class func parseResults(jsonResponse : NSDictionary) -> (Array<BingSearchResult>?, error : NSError?) {
        var result : Array<BingSearchResult>?
        
        var error : NSError?
        
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
                        if let searchResultObject = BingSearchResult(dictionary: searchResult)
                        {
                            result!.append(searchResultObject)
                        } else
                        {
                            // TODO: count unparsable results
                            error = NSError(domain: "Unable to parse search result \(searchResult) into BingSearchResult object", code: 0, userInfo: nil)
                        }
                    }
                }
            }
        }
        
        return (result, error)
    }
}
