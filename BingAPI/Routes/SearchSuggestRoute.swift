//
//  SearchSuggestRoute.swift
//  BingAPI
//
//  Created by Ian on 6/12/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

class SearchSuggestRoute: RouteBase {
    override internal class var baseUrl : NSURL? {
        get {
            return NSURL(string: "http://api.bing.com")
        }
    }
    
    override internal class var path : String {
        get {
            return "/osjson.aspx"
        }
    }
    
    var searchText : String
    
    init(searchText : String, timeoutInterval : NSTimeInterval = RouteBase.defaultTimeout, cachePolicy : NSURLRequestCachePolicy = RouteBase.defaultCachePolicy) {
        self.searchText = searchText
        
        super.init(timeoutInterval: timeoutInterval, cachePolicy: cachePolicy)
    }
    
    override internal var query : String {
        get {
            var result = ""
            
            if count(self.searchText) > 0
            {
                if let encodedSearchText = self.dynamicType.encodeString(self.searchText)
                {
                    RouteBase.addParameter(&result, parameter: "query=\(encodedSearchText)")
                } else
                {
                    NSLog("Warning: Unable to encode search text '\(self.searchText)' for Url, using original search text string")
                    
                    RouteBase.addParameter(&result, parameter: "query=\(self.searchText)")
                    
                }
            }
            
            return result
        }
    }
    
    func start(configureUrlRequest : ( (urlRequest : NSMutableURLRequest) -> Void)?,
                resultsHandler : ( (results : Array<String>?, error : NSError?) -> Void) ) {
        
        let task = self.jsonTask(configureUrlRequest: configureUrlRequest) { (jsonObject, error) -> Void in
            if let jsonArray = jsonObject as? NSArray
            {
                var results = self.dynamicType.parseResults(jsonArray)
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
    
    internal class func parseResults(jsonResponse : NSArray) -> (Array<String>?, error : NSError?) {
        var result : Array<String>?
        
        var error : NSError?
        
        for baseEntry in jsonResponse
        {
            if let suggestions = baseEntry as? NSArray
            {
                for suggestionObject in suggestions
                {
                    if let suggestion = suggestionObject as? String
                    {
                        if result == nil
                        {
                            result = Array<String>()
                        }
                        result?.append(suggestion)
                    }
                }
            }
        }
        
        return (result, error)
    }
}
